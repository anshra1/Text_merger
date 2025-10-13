import 'dart:io';

class ExportPreview {
  ExportPreview({
    required this.estimatedTokenCount,
    required this.estimatedSizeInMB,
    required this.estimatedPartsCount,
    required this.totalFiles,

    required this.failedFiles,
    required this.failedFilePaths,
    required this.successfulCombinedFilesPaths,
    required this.successedReturnedFiles,
  });

  final int estimatedTokenCount;
  final double estimatedSizeInMB;
  final int estimatedPartsCount;

  final int totalFiles;

  final int failedFiles;
  final List<String> failedFilePaths;
  final List<String> successfulCombinedFilesPaths;
  final List<File> successedReturnedFiles;
}
