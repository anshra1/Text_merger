//
// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_merger/features/code_combiner/data/enum/node_type.dart';
import 'package:text_merger/features/code_combiner/data/enum/selection_state.dart';
import 'package:text_merger/features/code_combiner/data/models/export_preview.dart';
import 'package:text_merger/features/code_combiner/data/models/file_node.dart';
import 'package:text_merger/features/code_combiner/data/models/filter_settings.dart';
import 'package:text_merger/features/code_combiner/domain/repositories/code_combiner_repository.dart';
import 'package:text_merger/features/code_combiner/domain/usecases/code_combiner_usecase.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/file_explorer_state.dart';

/// FileExplorerCubit following Clean Architecture with proper sealed states
/// Manages file tree selection, filtering, and expansion with optimal memory usage
class FileExplorerCubit extends Cubit<FileExplorerState> {
  FileExplorerCubit({required this.useCase}) : super(const FileExplorerInitial());

  final CodeCombinerUseCase useCase;

  // ==================== LOCAL SESSION VARIABLES ====================
  // Memory efficient - only stored locally, not in state
  Map<String, FileNode> _allNodes = {}; // Fixed after scan
  final Set<String> _selectedFileIds = {}; // Selection tracking
  final Map<String, bool> _expansionStates = {}; // Folder expand/collapse
  FilterSettings _currentFilterSettings = FilterSettings.defaults();

  // ==================== INITIALIZATION ====================

  /// Initialize workspace with existing data
  Future<void> initializeFromWorkspaceData(WorkspaceData workspaceData) async {
    emit(const FileExplorerLoading());

    // Store complete tree locally
    _allNodes = workspaceData.fileTree;

    // Use filter settings from the provided workspace data
    _currentFilterSettings = workspaceData.filterSettings;

    // Compute initial filtered nodes and emit
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes));
  }

  /// Initialize workspace - scan directory and load settings with 20-second timeout
  Future<void> initialize(String workspacePath) async {
    emit(const FileExplorerLoading());

    try {
      final result = await useCase
          .openDirectoryTree(workspacePath)
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw TimeoutException(
                'Folder too large',
                const Duration(seconds: 20),
              );
            },
          );

      await result.fold(
        (failure) async => emit(FileExplorerError(failure.message ?? 'Unknown error')),
        (workspaceData) async {
          // Store complete tree locally (one-time scan per session)
          _allNodes = workspaceData.fileTree;

          // Now, fetch the saved filter settings to override any defaults
          final settingsResult = await useCase.getFilterSettings();
          settingsResult.fold(
            (settingsFailure) {
              // If loading settings fails, fall back to the ones from the workspace
              _currentFilterSettings = workspaceData.filterSettings;
            },
            (savedSettings) {
              _currentFilterSettings = savedSettings;
            },
          );

          // Compute initial filtered nodes and emit
          final filteredNodes = _computeFilteredNodes();
          emit(FileExplorerLoaded(filteredNodes));
        },
      );
    } on TimeoutException {
      // Handle timeout specifically
      final fileCount = _countFilesInDirectory(workspacePath);
      emit(FileExplorerTimeout(fileCount, workspacePath));
    } catch (e) {
      emit(FileExplorerError('An unexpected error occurred: $e'));
    }
  }

  /// Count files in directory for timeout feedback
  int _countFilesInDirectory(String directoryPath) {
    try {
      final directory = Directory(directoryPath);
      if (!directory.existsSync()) return 0;

      var count = 0;
      directory.listSync(recursive: true).forEach((entity) {
        if (entity is File) count++;
      });
      return count;
    } catch (e) {
      return 0;
    }
  }

  // ==================== SELECTION MANAGEMENT ====================

  /// Toggle node selection with real-time ancestor updates
  void toggleNodeSelection(String nodeId) {
    final node = _allNodes[nodeId];
    if (node == null) return;

    final visibleNodeIds = currentFilteredNodes.keys.toSet();

    // Create working copy for atomic updates
    final updatedNodes = Map<String, FileNode>.from(_allNodes);

    if (node.type == NodeType.file) {
      _toggleFileSelection(nodeId, node, updatedNodes);
    } else {
      _toggleFolderSelection(nodeId, node, updatedNodes, visibleNodeIds);
    }

    // Real-time ancestor state updates
    _updateAncestorStates(nodeId, updatedNodes);

    // Store updated nodes locally
    _allNodes = updatedNodes;

    // Emit new filtered tree
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes));
  }

  void _toggleFileSelection(String fileId, FileNode file, Map<String, FileNode> nodes) {
    final newState = file.selectionState == SelectionState.checked
        ? SelectionState.unchecked
        : SelectionState.checked;

    nodes[fileId] = file.copyWith(selectionState: newState);

    // Update selection tracking
    if (newState == SelectionState.checked) {
      _selectedFileIds.add(fileId);
    } else {
      _selectedFileIds.remove(fileId);
    }
  }

  void _toggleFolderSelection(
    String folderId,
    FileNode folder,
    Map<String, FileNode> nodes,
    Set<String> visibleNodeIds,
  ) {
    final newState = folder.selectionState == SelectionState.checked
        ? SelectionState.unchecked
        : SelectionState.checked;

    _setFolderAndDescendants(folderId, newState, nodes, visibleNodeIds);
  }

  void _setFolderAndDescendants(
    String folderId,
    SelectionState state,
    Map<String, FileNode> nodes,
    Set<String> visibleNodeIds,
  ) {
    final folder = nodes[folderId];
    if (folder == null) return;

    // Safeguard: only proceed if the folder itself is visible.
    if (!visibleNodeIds.contains(folderId)) return;

    nodes[folderId] = folder.copyWith(selectionState: state);

    for (final childId in folder.childIds) {
      final child = nodes[childId];
      if (child == null) continue;

      // Only apply selection to visible nodes
      if (!visibleNodeIds.contains(childId)) continue;

      nodes[childId] = child.copyWith(selectionState: state);

      if (child.type == NodeType.file) {
        if (state == SelectionState.checked) {
          _selectedFileIds.add(childId);
        } else {
          _selectedFileIds.remove(childId);
        }
      } else {
        _setFolderAndDescendants(childId, state, nodes, visibleNodeIds);
      }
    }
  }

  void _updateAncestorStates(String nodeId, Map<String, FileNode> nodes) {
    final node = nodes[nodeId];
    if (node?.parentId == null) return;

    final parentId = node!.parentId!;
    final parent = nodes[parentId];
    if (parent?.type != NodeType.folder) return;

    final newParentState = _calculateFolderState(parentId, nodes);
    if (parent!.selectionState != newParentState) {
      nodes[parentId] = parent.copyWith(selectionState: newParentState);
      _updateAncestorStates(parentId, nodes); // Recursive upward propagation
    }
  }

  SelectionState _calculateFolderState(String folderId, Map<String, FileNode> nodes) {
    final folder = nodes[folderId];
    if (folder == null || folder.childIds.isEmpty) return SelectionState.unchecked;

    var checkedCount = 0;
    var hasIntermediate = false;

    for (final childId in folder.childIds) {
      final child = nodes[childId];
      if (child == null) continue;

      if (child.selectionState == SelectionState.checked) {
        checkedCount++;
      } else if (child.selectionState == SelectionState.intermediate) {
        hasIntermediate = true;
      }
    }

    if (hasIntermediate || (checkedCount > 0 && checkedCount < folder.childIds.length)) {
      return SelectionState.intermediate;
    }

    return checkedCount == folder.childIds.length
        ? SelectionState.checked
        : SelectionState.unchecked;
  }

  /// Clear all selections
  void clearAllSelections() {
    _selectedFileIds.clear();

    // Update all nodes to unchecked
    final clearedNodes = _allNodes.map(
      (id, node) => MapEntry(
        id,
        node.copyWith(selectionState: SelectionState.unchecked),
      ),
    );

    _allNodes = clearedNodes;

    // Emit updated filtered tree
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes));
  }

  // ==================== EXPANSION MANAGEMENT ====================

  /// Toggle folder expansion state
  void toggleFolderExpansion(String folderId) {
    final folder = _allNodes[folderId];
    if (folder?.type != NodeType.folder) return;

    _expansionStates[folderId] = !(_expansionStates[folderId] ?? false);

    // Emit state to trigger UI rebuild (expansion affects rendering)
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes, DateTime.now().millisecondsSinceEpoch));
  }

  /// Get expansion state for UI
  bool isFolderExpanded(String folderId) {
    return _expansionStates[folderId] ?? false;
  }

  // ==================== FILTERING SYSTEM ====================

  /// Public getter for the current filter settings to be displayed in the UI.
  FilterSettings get currentFilterSettings => _currentFilterSettings;

  /// Updates the set of blocked file extensions.
  void updateBlockedExtensions(String extensions) {
    final newSet = extensions
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet();
    _currentFilterSettings = _currentFilterSettings.copyWith(blockedExtensions: newSet);
    useCase.saveFilterSettings(_currentFilterSettings);
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes, DateTime.now().millisecondsSinceEpoch));
  }

  /// Updates the sets of blocked folder and file names from a single string.
  void updateBlockedFoldersAndFiles(String names) {
    final newFolders = <String>{};
    final newFiles = <String>{};
    final entries = names.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);

    for (final entry in entries) {
      if (entry.endsWith('/')) {
        newFolders.add(entry.substring(0, entry.length - 1)); // Remove trailing slash
      } else {
        newFiles.add(entry);
      }
    }

    _currentFilterSettings = _currentFilterSettings.copyWith(
      blockedFolderNames: newFolders,
      blockedFileNames: newFiles,
    );
    useCase.saveFilterSettings(_currentFilterSettings);
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes, DateTime.now().millisecondsSinceEpoch));
  }

  /// Updates the flag for including hidden files.
  void toggleIncludeHiddenFiles(bool value) {
    _currentFilterSettings = _currentFilterSettings.copyWith(includeHiddenFiles: value);
    useCase.saveFilterSettings(_currentFilterSettings);
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes, DateTime.now().millisecondsSinceEpoch));
  }

  final Map<String, bool> _visibilityCache = {};

  /// Apply search query filter.
  void applySearchQuery(String query) {
    _currentFilterSettings = _currentFilterSettings.copyWith(
      searchQuery: query,
    );
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes, DateTime.now().millisecondsSinceEpoch));
  }

  /// Apply positive filters (session-only, UI display filtering)
  void applyPositiveFilters(Set<String> allowedExtensions) {
    _currentFilterSettings = _currentFilterSettings.copyWith(
      allowedExtensions: allowedExtensions,
    );

    // Recompute filtered tree and emit
    final filteredNodes = _computeFilteredNodes();
    emit(FileExplorerLoaded(filteredNodes, DateTime.now().millisecondsSinceEpoch));
  }

  /// Update negative filters (from datasource with selection cleanup)
  Future<void> updateNegativeFilters() async {
    // Keep current tree visible with loading indicator
    final currentFilteredNodes = _computeFilteredNodes();
    emit(FileExplorerFilterUpdating(currentFilteredNodes));

    try {
      final result = await useCase.getFilterSettings();

      result.fold(
        (failure) {
          emit(FileExplorerError(failure.message ?? 'Unknown error'));
        },
        (newFilterSettings) {
          // Count selections before cleanup
          final beforeCount = _selectedFileIds.length;

          // Remove selected files that no longer pass negative filters
          _selectedFileIds.removeWhere((fileId) {
            final node = _allNodes[fileId];
            return node != null && !_passesNegativeFilter(node, newFilterSettings);
          });

          final removedCount = beforeCount - _selectedFileIds.length;

          // Update selection states in _allNodes for cleaned selections
          final updatedNodes = Map<String, FileNode>.from(_allNodes);
          for (final entry in updatedNodes.entries) {
            final fileId = entry.key;
            final node = entry.value;

            if (node.selectionState == SelectionState.checked &&
                !_selectedFileIds.contains(fileId)) {
              updatedNodes[fileId] = node.copyWith(
                selectionState: SelectionState.unchecked,
              );
            }
          }

          // Update ancestor states after selection cleanup
          for (final fileId in updatedNodes.keys) {
            if (!_selectedFileIds.contains(fileId)) {
              _updateAncestorStates(fileId, updatedNodes);
            }
          }

          // Store updated data
          _allNodes = updatedNodes;
          _currentFilterSettings = newFilterSettings.copyWith(
            allowedExtensions:
                _currentFilterSettings.allowedExtensions, // Keep positive filters
          );

          // Show success with feedback
          final newFilteredNodes = _computeFilteredNodes();
          emit(FileExplorerFilterUpdateSuccess(newFilteredNodes, removedCount));

          // Auto-transition to loaded state
          Future.delayed(const Duration(seconds: 2), () {
            if (state is FileExplorerFilterUpdateSuccess) {
              emit(FileExplorerLoaded(newFilteredNodes));
            }
          });
        },
      );
    } on Exception catch (e) {
      emit(FileExplorerError('Failed to update filters: $e'));
    }
  }

  /// Compute filtered nodes using a recursive visibility check.
  /// This prunes empty folders and respects all filters.
  Map<String, FileNode> _computeFilteredNodes() {
    _visibilityCache.clear();
    final visibleNodes = <String, FileNode>{};
    for (final entry in _allNodes.entries) {
      if (_isNodeVisible(entry.key, _currentFilterSettings)) {
        visibleNodes[entry.key] = entry.value;
      }
    }
    return visibleNodes;
  }

  /// Recursively determines if a node is visible based on filters and content.
  /// Uses memoization for performance.
  bool _isNodeVisible(String nodeId, FilterSettings settings) {
    if (_visibilityCache.containsKey(nodeId)) {
      return _visibilityCache[nodeId]!;
    }

    final node = _allNodes[nodeId];
    if (node == null) {
      _visibilityCache[nodeId] = false;
      return false;
    }

    // All nodes must pass negative filters.
    if (!_passesNegativeFilter(node, settings)) {
      _visibilityCache[nodeId] = false;
      return false;
    }

    bool isVisible;
    if (node.type == NodeType.file) {
      // Files must also pass positive (extension) and search filters.
      isVisible =
          _passesPositiveFilter(node, settings) && _passesSearchQuery(node, settings);
    } else {
      // A folder is visible if any of its children are visible.
      isVisible = node.childIds.any((childId) => _isNodeVisible(childId, settings));
    }

    _visibilityCache[nodeId] = isVisible;
    return isVisible;
  }

  bool _passesSearchQuery(FileNode node, FilterSettings settings) {
    final searchQuery = settings.searchQuery?.trim().toLowerCase();
    if (searchQuery == null || searchQuery.isEmpty) {
      return true; // No search query means everything passes.
    }
    // The search query must be contained in the node's name.
    return node.name.toLowerCase().contains(searchQuery);
  }

  /// Check if node passes negative filters (blocked items)
  bool _passesNegativeFilter(FileNode node, FilterSettings settings) {
    // Check blocked extensions
    if (settings.blockedExtensions.any((ext) => node.path.endsWith(ext))) {
      return false;
    }

    // Check blocked paths
    if (settings.blockedFilePaths.any((path) => node.path.contains(path))) {
      return false;
    }

    // Check blocked file names
    if (settings.blockedFileNames.contains(node.name)) {
      return false;
    }

    // Check blocked folder names
    if (settings.blockedFolderNames.any((folder) => node.path.contains('/$folder/'))) {
      return false;
    }

    // Check hidden files
    if (!settings.includeHiddenFiles && node.name.startsWith('.')) {
      return false;
    }

    return true;
  }

  /// Check if node passes positive filters (allowed items)
  bool _passesPositiveFilter(FileNode node, FilterSettings settings) {
    // If no positive filters, show all files
    if (settings.allowedExtensions.isEmpty) {
      return true;
    }

    // For positive filters, only files can pass on their own.
    // Folders pass if they have a descendant that passes.
    if (node.type == NodeType.folder) {
      return true; // This is handled by the recursive _isNodeVisible check
    }

    // Check if file extension is allowed
    return settings.allowedExtensions.any((ext) => node.path.endsWith(ext));
  }

  // ==================== EXPORT OPERATIONS ====================

  /// Export selected files (delegates to datasource)
  /// [savePath] - Optional custom path for saving. If null, uses default location from settings
  /// Returns ExportPreview on success, null on failure or no selection
  Future<ExportPreview?> exportSelectedFiles({String? savePath}) async {
    if (_selectedFileIds.isEmpty) return null;

    emit(const FileExplorerLoading());

    // Convert selected IDs to file paths
    final selectedPaths = _selectedFileIds
        .map((id) => _allNodes[id]?.path)
        .whereType<String>()
        .toList();

    final result = await useCase.exportFiles(selectedPaths, customSavePath: savePath);
    return result.fold(
      (failure) {
        emit(FileExplorerError(failure.message ?? 'Unknown error'));
        return null;
      },
      (exportPreview) {
        // Export successful - return to loaded state
        final filteredNodes = _computeFilteredNodes();
        emit(FileExplorerLoaded(filteredNodes));
        return exportPreview;
      },
    );
  }

  // ==================== PUBLIC GETTERS ====================

  /// Get current selection count for UI display
  int get selectedFilesCount => _selectedFileIds.length;

  /// Get current filtered nodes for external access
  Map<String, FileNode> get currentFilteredNodes {
    if (state is FileExplorerLoaded) {
      return (state as FileExplorerLoaded).filteredNodes;
    } else if (state is FileExplorerFilterUpdating) {
      return (state as FileExplorerFilterUpdating).filteredNodes;
    } else if (state is FileExplorerFilterUpdateSuccess) {
      return (state as FileExplorerFilterUpdateSuccess).filteredNodes;
    }
    return {};
  }
}
