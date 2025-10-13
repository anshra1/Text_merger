import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_merger/core/error/exception.dart';
import 'package:text_merger/features/code_combiner/data/enum/node_type.dart';
import 'package:text_merger/features/code_combiner/data/enum/selection_state.dart';
import 'package:text_merger/features/code_combiner/data/models/app_settings.dart';
import 'package:text_merger/features/code_combiner/data/models/export_preview.dart';
import 'package:text_merger/features/code_combiner/data/models/file_node.dart';
import 'package:uuid/uuid.dart';

abstract class FileSystemDataSource {
  Future<Map<String, FileNode>> scanDirectory(String directoryPath);

  Future<String> readFileContent(String filePath);
  Future<ExportPreview> combineAndExportFiles(
    List<String> filePaths, {
    String? customSavePath,
  });
}

class FileSystemDataSourceImpl implements FileSystemDataSource {
  final Uuid _uuid = const Uuid();

  /// Purpose: Scan directory structure and build file tree nodes map
  @override
  Future<Map<String, FileNode>> scanDirectory(String directoryPath) async {
    try {
      // Input validation
      if (directoryPath.isEmpty) {
        throw const FileSystemException(
          methodName: 'scanDirectory',
          originalError: 'Directory path is empty',
          userMessage: 'Please provide a valid directory path',
          title: 'Invalid Directory Path',
        );
      }

      final normalizedPath = _normalizePath(directoryPath);

      if (!_isValidPath(normalizedPath)) {
        throw FileSystemException(
          methodName: 'scanDirectory',
          originalError: 'Invalid directory path: $normalizedPath',
          userMessage: 'The provided directory path is not valid',
          title: 'Invalid Directory Path',
        );
      }

      final directory = Directory(normalizedPath);

      // Check if directory exists and is accessible
      if (!directory.existsSync()) {
        throw FileSystemException(
          methodName: 'scanDirectory',
          originalError: 'Directory does not exist: $normalizedPath',
          userMessage: 'The selected directory does not exist',
          title: 'Directory Not Found',
        );
      }

      if (!await isAccessible(normalizedPath)) {
        throw const FileSystemException(
          methodName: 'scanDirectory',
          originalError: 'Permission denied to access directory',
          userMessage: 'Access denied. Please check directory permissions',
          title: 'Permission Denied',
        );
      }

      // Initialize the nodes map
      final nodes = <String, FileNode>{};

      // Create root directory node
      final rootId = _uuid.v4();
      // use to create top folder node
      final rootNode = _createFileNode(directory, null);

      final rootNodeWithId = FileNode(
        id: rootId,
        name: rootNode.name,
        path: rootNode.path,
        type: rootNode.type,
        selectionState: rootNode.selectionState,
        isExpanded: false,
        childIds: [],
      );

      nodes[rootId] = rootNodeWithId;

      // Recursively scan the directory
      await _scanDirectoryRecursive(directory, rootId, nodes);

      return nodes;
    } on FileSystemException {
      rethrow;
    } catch (e, stackTrace) {
      throw FileSystemException(
        methodName: 'scanDirectory',
        originalError: e.toString(),
        userMessage: 'Failed to scan directory structure',
        title: 'Directory Scan Failed',
        stackTrace: stackTrace.toString(),
        debugDetails: 'Directory path: $directoryPath',
      );
    }
  }

  bool _isValidPath(String pathString) {
    /// Purpose: Validate if the provided path is valid and safe
    try {
      if (pathString.isEmpty) return false;

      // Check for null bytes which could be security risks
      if (pathString.contains('\x00')) return false;

      // Check if path is absolute
      if (!path.isAbsolute(pathString)) return false;

      // Check for dangerous path traversal patterns
      if (pathString.contains('..')) return false;

      return true;
    } on FileSystemException {
      return false;
    }
  }

  String _normalizePath(String pathString) {
    /// Purpose: Normalize the path for consistent handling across platforms
    try {
      // Normalize the path using the path package
      // it erase all the extra spaces characters
      return path.normalize(pathString.trim());
    } on Exception catch (_) {
      return pathString.trim();
    }
  }

  /// Purpose: Create a FileNode from FileSystemEntity
  FileNode _createFileNode(FileSystemEntity entity, String? parentId) {
    final entityPath = entity.path;
    final entityName = path.basename(entityPath);
    final isDirectory = entity is Directory;

    return FileNode(
      id: _uuid.v4(),
      name: entityName,
      path: entityPath,
      type: isDirectory ? NodeType.folder : NodeType.file,
      selectionState: SelectionState.unchecked,
      isExpanded: false,
      parentId: parentId,
      childIds: [],
    );
  }

  /// Purpose: Get all child paths from a directory
  Future<List<String>> _getChildPaths(String directoryPath) async {
    try {
      final directory = Directory(directoryPath);
      final entities = await directory.list().toList();
      return entities.map((entity) => entity.path).toList();
    } on FileSystemException {
      // Log the error but return empty list to continue scanning
      return [];
    }
  }

  /// Purpose: Read content from a single file with proper validation and size checking
  @override
  Future<String> readFileContent(String filePath) async {
    try {
      // 1. Validate Input - Check if filePath is empty/null
      if (filePath.isEmpty) {
        throw const FileSystemException(
          methodName: 'readFileContent',
          originalError: 'File path is empty',
          userMessage: 'Invalid file path',
          title: 'Invalid File Path',
        );
      }

      // 2. Check File Exists - Verify file exists using File(filePath).existsSync()
      final file = File(filePath);
      if (!file.existsSync()) {
        throw FileSystemException(
          methodName: 'readFileContent',
          originalError: 'File not found: $filePath',
          userMessage: 'File does not exist',
          title: 'File Not Found',
        );
      }

      // 3. Check Accessibility - Use existing isAccessible() method
      if (!await isAccessible(filePath)) {
        throw FileSystemException(
          methodName: 'readFileContent',
          originalError: 'Permission denied: $filePath',
          userMessage: 'Permission denied to read file',
          title: 'Permission Denied',
        );
      }

      // 4. Check if Binary - Use existing isBinaryFile() method
      if (isBinaryFile(filePath)) {
        throw FileSystemException(
          methodName: 'readFileContent',
          originalError: 'Binary file detected: $filePath',
          userMessage: 'Cannot read binary file as text',
          title: 'Binary File Error',
        );
      }

      // 5. Get File Size - Use existing getFileSize() method
      final fileSizeBytes = await getFileSize(filePath);

      // 6. Size Check - If > 5MB, throw FileSystemException with "File too large (X MB)" message
      const maxSizeBytes = 5 * 1024 * 1024; // 5MB in bytes
      if (fileSizeBytes > maxSizeBytes) {
        final fileSizeMB = _convertBytesToMB(fileSizeBytes);
        throw FileSystemException(
          methodName: 'readFileContent',
          originalError: 'File size exceeds limit: $fileSizeMB MB',
          userMessage: 'File too large ($fileSizeMB MB). Use external editor.',
          title: 'File Too Large',
        );
      }

      // 7. Read File - Use File(filePath).readAsString() for files ≤ 5MB
      final content = await file.readAsString();

      // 8. Return content - Return the file content as String
      return content;
    } on FileSystemException {
      rethrow;
    } catch (e, stackTrace) {
      throw FileSystemException(
        methodName: 'readFileContent',
        originalError: e.toString(),
        userMessage: 'Failed to read file content',
        title: 'File Read Error',
        stackTrace: stackTrace.toString(),
        debugDetails: 'File path: $filePath',
      );
    }
  }

  /// Purpose: Check if the path is accessible for reading

  Future<bool> isAccessible(String path) async {
    try {
      // Determine what the path points to without following symlinks.
      // Returns one of: file, directory, link, notFound.
      final entity = FileSystemEntity.typeSync(path);
      if (entity == FileSystemEntityType.notFound) {
        return false;
      }

      if (entity == FileSystemEntityType.directory) {
        final directory = Directory(path);
        // Try to list contents to check read permission
        await directory.list(followLinks: false).take(1).toList();
        return true;
      } else {
        // Try to read file stats to check accessibility
        File(path).statSync();
        return true;
      }
    } on Exception catch (_) {
      return false;
    }
  }

  /// Purpose: Recursively scan directory and build file tree structure
  Future<void> _scanDirectoryRecursive(
    Directory directory,
    String parentId,
    Map<String, FileNode> nodes,
  ) async {
    try {
      final entities = await directory.list(followLinks: false).toList();

      final childIds = <String>[];

      for (final entity in entities) {
        try {
          // Skip if not accessible
          if (!await isAccessible(entity.path)) {
            continue;
          }

          final childNode = _createFileNode(entity, parentId);
          nodes[childNode.id] = childNode;
          childIds.add(childNode.id);

          // If it's a directory, recursively scan it
          if (entity is Directory) {
            await _scanDirectoryRecursive(entity, childNode.id, nodes);
          }
        } on FileSystemException {
          // Log the error but continue scanning other files
          // This ensures one problematic file doesn't stop the entire scan
          continue;
        }
      }

      // Update parent node with child IDs
      final parentNode = nodes[parentId];
      if (parentNode != null) {
        nodes[parentId] = parentNode.copyWith(childIds: childIds);
      }
    } on FileSystemException {
      // If we can't scan this directory, just continue
      // The parent will have an empty childIds list
      return;
    }
  }

  bool _checkPermissions(String path) {
    try {
      final entity = File(path).existsSync() ? File(path) : Directory(path);
      if (!entity.existsSync()) return false;

      // Try to access the entity to test permissions
      if (entity is Directory) {
        entity.listSync();
      } else {
        (entity as File).readAsStringSync();
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<int> getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw FileSystemException(
          methodName: 'getFileSize',
          originalError: 'File not found: $filePath',
          userMessage: 'The specified file does not exist',
          title: 'File Not Found',
        );
      }
      return await file.length();
    } catch (e) {
      throw FileSystemException(
        methodName: 'getFileSize',
        originalError: e.toString(),
        userMessage: 'Unable to determine file size',
        title: 'File Access Error',
      );
    }
  }

  int _convertBytesToMB(int bytes) {
    return (bytes / (1024 * 1024)).round();
  }

  bool isBinaryFile(String filePath) {
    final extension = _extractFileExtension(filePath).toLowerCase();
    return _getBinaryExtensions().contains(extension);
  }

  String _extractFileExtension(String filePath) {
    return path.extension(filePath);
  }

  Set<String> _getBinaryExtensions() {
    return {
      '.exe',
      '.dll',
      '.so',
      '.dylib',
      '.png',
      '.jpg',
      '.jpeg',
      '.gif',
      '.ico',
      '.bmp',
      '.tiff',
      '.zip',
      '.tar',
      '.gz',
      '.rar',
      '.7z',
      '.bz2',
      '.pdf',
      '.doc',
      '.docx',
      '.xls',
      '.xlsx',
      '.ppt',
      '.pptx',
      '.mp3',
      '.mp4',
      '.avi',
      '.mov',
      '.wav',
      '.flv',
      '.bin',
      '.iso',
      '.dmg',
      '.pkg',
      '.deb',
      '.rpm',
    };
  }

  Future<bool> isValidDirectory(String path) async {
    try {
      if (path.isEmpty) return false;
      final directory = Directory(path);
      return directory.existsSync() &&
          _isActualDirectory(path) &&
          _hasReadPermission(path);
    } on Exception catch (_) {
      return false;
    }
  }

  bool _hasReadPermission(String path) {
    try {
      final directory = Directory(path);
      if (!directory.existsSync()) return false;

      // Try to list directory contents to test read permission
      directory.listSync();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  bool _isActualDirectory(String path) {
    try {
      final entity = Directory(path);
      return entity.existsSync() &&
          entity.statSync().type == FileSystemEntityType.directory;
    } on Exception catch (_) {
      return false;
    }
  }

  /// Method Purpose: Takes a list of file paths, reads all their
  /// contents, combines into one string, splits if too large, and returns
  /// list of created files
  /// [customSavePath] - Optional custom path for saving. If null, uses default location from settings
  @override
  Future<ExportPreview> combineAndExportFiles(
    List<String> filePaths, {
    String? customSavePath,
  }) async {
    final failedFilePaths = <String>[];
    final successfulCombinedFilesPaths = <String>[];

    try {
      // Step 1: Load AppSettings from SharedPreferences
      final appSettings = await _loadAppSettings();

      // Step 2: Read each file and track failed/successful files
      final validFilesContent = await _readAndFilterFilesWithTracking(
        filePaths,
        appSettings.fileSplitSizeInMB,
        failedFilePaths,
        successfulCombinedFilesPaths,
        appSettings,
      );

      // Step 3: Combine valid file contents with headers and summary
      final combinedContent = _combineWithHeaders(
        validFilesContent,
        successfulCombinedFilesPaths,
        failedFilePaths,
        filePaths.length,
      );

      // Step 4: Calculate statistics
      final estimatedTokenCount = _estimateTokenCount(combinedContent);
      final estimatedSizeInMB = _calculateSizeInMB(combinedContent);
      final contentChunks = _splitContent(combinedContent, appSettings.fileSplitSizeInMB);
      final estimatedPartsCount = contentChunks.length;

      // Step 5: Save split files to custom path or defaultExportLocation directory
      final exportLocation = customSavePath ?? appSettings.defaultExportLocation;
      final createdFiles = await _saveFiles(
        contentChunks,
        exportLocation,
      );

      // Step 6: Return detailed ExportPreview
      return ExportPreview(
        estimatedTokenCount: estimatedTokenCount,
        estimatedSizeInMB: estimatedSizeInMB,
        estimatedPartsCount: estimatedPartsCount,
        totalFiles: filePaths.length,
        failedFiles: failedFilePaths.length,
        failedFilePaths: failedFilePaths,
        successfulCombinedFilesPaths: successfulCombinedFilesPaths,
        successedReturnedFiles: createdFiles,
      );
    } catch (e, stackTrace) {
      throw FileSystemException(
        methodName: 'combineAndExportFiles',
        originalError: e.toString(),
        userMessage: 'Failed to combine and export files',
        title: 'Export Failed',
        stackTrace: stackTrace.toString(),
        debugDetails: 'File paths: ${filePaths.join(', ')}',
      );
    }
  }

  /// Step 1: Load AppSettings from SharedPreferences
  Future<AppSettings> _loadAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('app_settings');

      if (jsonString == null || jsonString.isEmpty) {
        return AppSettings.defaultsWithDocumentsPath();
      }

      final data = Map<String, dynamic>.from(
        jsonDecode(jsonString) as Map,
      );
      return AppSettings.fromJson(data);
    } on Exception {
      // Fallback to defaults if loading fails
      return AppSettings.defaultsWithDocumentsPath();
    }
  }

  /// Step 2: Read and filter files based on size limit with batch processing
  Future<Map<String, String>> _readAndFilterFiles(
    List<String> filePaths,
    int maxSizeInMB,
  ) async {
    final validFiles = <String, String>{};
    const batchSize = 10;
    final maxSizeBytes = maxSizeInMB * 1024 * 1024;

    // Process files in batches
    for (var i = 0; i < filePaths.length; i += batchSize) {
      final end = (i + batchSize < filePaths.length) ? i + batchSize : filePaths.length;
      final batch = filePaths.sublist(i, end);

      await Future.wait(
        batch.map((filePath) async {
          try {
            // Check if file exists and is accessible
            final file = File(filePath);
            if (!file.existsSync() || !await isAccessible(filePath)) {
              return;
            }

            // Check if file is binary
            if (isBinaryFile(filePath)) {
              return;
            }

            // Check file size
            final fileSize = await getFileSize(filePath);
            if (fileSize > maxSizeBytes) {
              return; // Skip oversized files
            }

            // Read file content
            final content = await readFileContent(filePath);
            validFiles[filePath] = content;
          } on Exception {
            // Skip files that can't be read
            return;
          }
        }),
      );
    }

    return validFiles;
  }

  /// Step 2 Enhanced: Read and filter files with tracking of failed/successful files
  Future<Map<String, String>> _readAndFilterFilesWithTracking(
    List<String> filePaths,
    int maxSizeInMB,
    List<String> failedFilePaths,
    List<String> successfulCombinedFilesPaths,
    AppSettings appSettings,
  ) async {
    final validFiles = <String, String>{};
    const batchSize = 10;
    final maxSizeBytes = maxSizeInMB * 1024 * 1024;

    // Process files in batches
    for (var i = 0; i < filePaths.length; i += batchSize) {
      final end = (i + batchSize < filePaths.length) ? i + batchSize : filePaths.length;
      final batch = filePaths.sublist(i, end);

      await Future.wait(
        batch.map((filePath) async {
          try {
            // Check if file exists and is accessible
            final file = File(filePath);
            if (!file.existsSync() || !await isAccessible(filePath)) {
              failedFilePaths.add(filePath);
              return;
            }

            // Check if file is binary
            if (isBinaryFile(filePath)) {
              failedFilePaths.add(filePath);
              return;
            }

            // Check file size
            final fileSize = await getFileSize(filePath);
            if (fileSize > maxSizeBytes) {
              failedFilePaths.add(filePath);
              return; // Skip oversized files
            }

            // Read file content
            var content = await readFileContent(filePath);

            // Apply comment stripping if enabled
            content = _stripCommentsFromContent(
              content,
              appSettings.stripCommentsFromCode,
            );

            validFiles[filePath] = content;
            successfulCombinedFilesPaths.add(filePath);
          } on Exception {
            // Track files that can't be read
            failedFilePaths.add(filePath);
            return;
          }
        }),
      );
    }

    return validFiles;
  }

  /// Calculate estimated token count (approximate: characters / 4)
  int _estimateTokenCount(String content) {
    // Common approximation: 1 token ≈ 4 characters for English text
    return (content.length / 4).round();
  }

  /// Calculate content size in MB
  double _calculateSizeInMB(String content) {
    final sizeInBytes = content.codeUnits.length;
    return sizeInBytes / (1024 * 1024);
  }

  /// Strip comments from code content selectively
  /// Removes: // single-line comments and /* multi-line comments */
  /// Preserves: /// documentation comments and /** doc blocks */
  String _stripCommentsFromContent(String content, bool shouldStrip) {
    if (!shouldStrip) return content;

    final lines = content.split('\n');
    final processedLines = <String>[];
    var insideMultiLineComment = false;

    for (final line in lines) {
      final processedLine = line;
      var i = 0;
      final result = StringBuffer();

      while (i < processedLine.length) {
        // Handle multi-line comments /* */
        if (!insideMultiLineComment &&
            i < processedLine.length - 1 &&
            processedLine[i] == '/' &&
            processedLine[i + 1] == '*') {
          // Check if it's a documentation comment /** */
          final isDocComment =
              i < processedLine.length - 2 && processedLine[i + 2] == '*';

          if (isDocComment) {
            // Keep documentation comment, find the end
            final endIndex = processedLine.indexOf('*/', i + 3);
            if (endIndex != -1) {
              result.write(processedLine.substring(i, endIndex + 2));
              i = endIndex + 2;
            } else {
              // Multi-line doc comment, keep this line
              result.write(processedLine.substring(i));
              break;
            }
          } else {
            // Regular multi-line comment, start removing
            final endIndex = processedLine.indexOf('*/', i + 2);
            if (endIndex != -1) {
              // Single-line /* */ comment, skip it
              i = endIndex + 2;
            } else {
              // Multi-line comment starts here, skip rest of line
              insideMultiLineComment = true;
              break;
            }
          }
        }
        // Handle end of multi-line comment
        else if (insideMultiLineComment) {
          final endIndex = processedLine.indexOf('*/', i);
          if (endIndex != -1) {
            insideMultiLineComment = false;
            i = endIndex + 2;
          } else {
            // Still inside comment, skip entire line
            break;
          }
        }
        // Handle single-line comments //
        else if (i < processedLine.length - 1 &&
            processedLine[i] == '/' &&
            processedLine[i + 1] == '/') {
          // Check if it's a documentation comment ///
          final isDocComment =
              i < processedLine.length - 2 && processedLine[i + 2] == '/';

          if (isDocComment) {
            // Keep documentation comment
            result.write(processedLine.substring(i));
            break;
          } else {
            // Regular single-line comment, remove rest of line
            break;
          }
        }
        // Handle strings to avoid removing comments inside strings
        else if (processedLine[i] == '"' || processedLine[i] == "'") {
          final quote = processedLine[i];
          result.write(processedLine[i]);
          i++;

          // Find closing quote, handling escape sequences
          while (i < processedLine.length) {
            if (processedLine[i] == r'\' && i < processedLine.length - 1) {
              // Escape sequence, add both characters
              result
                ..write(processedLine[i])
                ..write(processedLine[i + 1]);
              i += 2;
            } else if (processedLine[i] == quote) {
              // Found closing quote
              result.write(processedLine[i]);
              i++;
              break;
            } else {
              result.write(processedLine[i]);
              i++;
            }
          }
        } else {
          result.write(processedLine[i]);
          i++;
        }
      }

      // Add processed line if not completely inside a multi-line comment
      if (!insideMultiLineComment || result.isNotEmpty) {
        processedLines.add(result.toString().trimRight());
      }
    }

    return processedLines.join('\n');
  }

  /// Step 3: Combine file contents with path headers and summary
  String _combineWithHeaders(
    Map<String, String> filesContent,
    List<String> successfulPaths,
    List<String> failedPaths,
    int totalFiles,
  ) {
    final buffer = StringBuffer()
      // Add summary header at the top
      ..writeln('EXPORT SUMMARY')
      ..writeln('==============')
      ..writeln('Total Files Processed: $totalFiles')
      ..writeln('Successfully Combined: ${successfulPaths.length} files')
      ..writeln('Failed Files: ${failedPaths.length} files')
      ..writeln();

    // Add successful files list
    if (successfulPaths.isNotEmpty) {
      buffer
        ..writeln('SUCCESSFULLY COMBINED FILES:')
        ..writeln('----------------------------');
      for (final filePath in successfulPaths) {
        buffer.writeln('✅ $filePath');
      }
      buffer.writeln();
    }

    // Add failed files list with reasons
    if (failedPaths.isNotEmpty) {
      buffer
        ..writeln('FAILED FILES:')
        ..writeln('-------------');
      for (final filePath in failedPaths) {
        final reason = _getFailureReason(filePath);
        buffer.writeln('❌ $filePath ($reason)');
      }
      buffer.writeln();
    }

    // Add separator before actual content
    buffer
      ..writeln('COMBINED CONTENT:')
      ..writeln('=================')
      ..writeln();

    // Add actual file contents with headers
    for (final entry in filesContent.entries) {
      final filePath = entry.key;
      final content = entry.value;

      buffer
        ..writeln('=== $filePath ===')
        ..writeln(content)
        ..writeln(); // Add empty line between files
    }

    return buffer.toString();
  }

  /// Helper method to determine failure reason for a file
  String _getFailureReason(String filePath) {
    final file = File(filePath);

    // Check if file doesn't exist
    if (!file.existsSync()) {
      return 'File not found';
    }

    // Check if it's a binary file
    if (isBinaryFile(filePath)) {
      return 'Binary file - skipped';
    }

    // Check if file is too large (approximate check)
    try {
      final size = file.lengthSync();
      if (size > 5 * 1024 * 1024) {
        // > 5MB
        return 'File too large - exceeds size limit';
      }
    } on Exception {
      return 'Access denied or permission error';
    }

    return 'Unknown error - failed to read';
  }

  /// Step 4: Split content into chunks based on size limit
  List<String> _splitContent(String content, int maxSizeInMB) {
    final maxSizeBytes = maxSizeInMB * 1024 * 1024;
    final contentBytes = content.codeUnits.length;

    if (contentBytes <= maxSizeBytes) {
      return [content];
    }

    final chunks = <String>[];
    var currentIndex = 0;

    while (currentIndex < content.length) {
      var endIndex = currentIndex + maxSizeBytes;
      if (endIndex > content.length) {
        endIndex = content.length;
      }

      // Try to break at a newline to avoid splitting in the middle of a line
      if (endIndex < content.length) {
        final lastNewlineIndex = content.lastIndexOf('\n', endIndex);
        if (lastNewlineIndex > currentIndex) {
          endIndex = lastNewlineIndex + 1;
        }
      }

      chunks.add(content.substring(currentIndex, endIndex));
      currentIndex = endIndex;
    }

    return chunks;
  }

  /// Step 5: Save split files with timestamp-based filename generation
  Future<List<File>> _saveFiles(
    List<String> contentChunks,
    String? exportLocation,
  ) async {
    final exportDir = await _getExportDirectory(exportLocation);
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];
    final createdFiles = <File>[];

    for (var i = 0; i < contentChunks.length; i++) {
      final filename = contentChunks.length == 1
          ? 'text_merger_$timestamp.txt'
          : 'text_merger_${timestamp}_part${i + 1}.txt';

      final file = File(path.join(exportDir.path, filename));
      await file.writeAsString(contentChunks[i]);
      createdFiles.add(file);
    }

    return createdFiles;
  }

  /// Helper: Get or create export directory
  Future<Directory> _getExportDirectory(String? exportLocation) async {
    late Directory exportDir;

    if (exportLocation != null && exportLocation.isNotEmpty) {
      exportDir = Directory(exportLocation);
    } else {
      // Fallback to Documents directory
      final appSettings = await AppSettings.defaultsWithDocumentsPath();
      exportDir = Directory(
        appSettings.defaultExportLocation ?? '${Directory.current.path}/exports',
      );
    }

    // Create directory if it doesn't exist
    if (!exportDir.existsSync()) {
      exportDir = await exportDir.create(recursive: true);
    }

    return exportDir;
  }
}
