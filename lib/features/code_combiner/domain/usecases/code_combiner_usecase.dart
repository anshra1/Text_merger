import 'package:text_merger/core/typedefs/type.dart';
import 'package:text_merger/features/code_combiner/data/models/app_settings.dart';
import 'package:text_merger/features/code_combiner/data/models/export_preview.dart';
import 'package:text_merger/features/code_combiner/data/models/filter_settings.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';
import 'package:text_merger/features/code_combiner/domain/repositories/code_combiner_repository.dart';

/// Single use case handling all Code Combiner business workflows
/// Orchestrates complex operations across file system and storage
class CodeCombinerUseCase {
  CodeCombinerUseCase({required this.repository});

  final CodeCombinerRepository repository;

  // ==================== Workspace Operations ====================

  /// Business workflow: Open directory tree with full setup
  ResultFuture<WorkspaceData> openDirectoryTree(String directoryPath) {
    return repository.openDirectoryTree(directoryPath);
  }

  /// Business workflow: Get recent workspaces
  ResultFuture<List<RecentWorkspace>> getRecentWorkspaces() {
    return repository.getRecentWorkspaces();
  }

  /// Business workflow: Remove workspace from recent list
  ResultFuture<List<RecentWorkspace>> removeRecentWorkspace(String workspacePath) {
    return repository.removeRecentWorkspace(workspacePath);
  }

  /// Business workflow: Toggle favorite for a recent workspace
  ResultFuture<List<RecentWorkspace>> toggleFavoriteRecentWorkspace(
    String workspacePath,
  ) {
    return repository.toggleFavoriteRecentWorkspace(workspacePath);
  }

  /// Business workflow: Clear all recent workspaces
  ResultFuture<List<RecentWorkspace>> clearRecentWorkspaces() {
    return repository.clearRecentWorkspaces();
  }

  // ==================== File Operations ====================

  /// Business workflow: Read file content safely
  ResultFuture<String> readFileContent(String filePath) {
    return repository.readFileContent(filePath);
  }

  /// Business workflow: Complete export process
  /// [customSavePath] - Optional custom path for saving. If null, uses default location from settings
  ResultFuture<ExportPreview> exportFiles(
    List<String> filePaths, {
    String? customSavePath,
  }) {
    return repository.exportFiles(filePaths, customSavePath: customSavePath);
  }

  // ==================== Settings Management ====================

  /// Business workflow: Get filter settings
  ResultFuture<FilterSettings> getFilterSettings() {
    return repository.getFilterSettings();
  }

  /// Business workflow: Save filter settings
  ResultFuture<bool> saveFilterSettings(FilterSettings settings) {
    return repository.saveFilterSettings(settings);
  }

  /// Business workflow: Get app settings
  ResultFuture<AppSettings> getAppSettings() {
    return repository.getAppSettings();
  }

  /// Business workflow: Save app settings
  ResultFuture<void> saveAppSettings(AppSettings settings) {
    return repository.saveAppSettings(settings);
  }
}
