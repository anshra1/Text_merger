import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';
import 'package:text_merger/features/code_combiner/domain/usecases/code_combiner_usecase.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit({
    required this.codeCombinerUseCase,
  }) : super(const WorkspaceInitial());

  final CodeCombinerUseCase codeCombinerUseCase;

  /// Load recent workspaces from storage
  Future<void> loadRecentWorkspaces() async {
    final currentWorkspaces = state is WorkspaceStateWithWorkspaces
        ? (state as WorkspaceStateWithWorkspaces).workspaces
        : <RecentWorkspace>[];
    emit(WorkspaceLoading(currentWorkspaces));

    final result = await codeCombinerUseCase.getRecentWorkspaces();

    result.fold(
      (failure) => emit(WorkspaceError(failure)),
      (workspaces) => emit(WorkspaceLoaded(workspaces)),
    );
  }

  /// Open directory tree: scan directory + load settings + add to recent
  Future<void> openDirectoryTree(String directoryPath) async {
    if (directoryPath.isEmpty) {
      return;
    }

    final currentWorkspaces = state is WorkspaceStateWithWorkspaces
        ? (state as WorkspaceStateWithWorkspaces).workspaces
        : <RecentWorkspace>[];
    emit(WorkspaceLoading(currentWorkspaces));

    final result = await codeCombinerUseCase.openDirectoryTree(directoryPath);

    result.fold(
      (failure) => emit(WorkspaceError(failure)),
      (workspaceData) {
        // Emit WorkspaceOpened state with the complete workspace data
        // This includes file tree, settings, and workspace path
        emit(WorkspaceOpened(workspaceData));
        loadRecentWorkspaces();

        // The UI can now:
        // 1. Navigate to file explorer with the loaded file tree
        // 2. Initialize other cubits with the workspace data
        // 3. Display workspace information
      },
    );
  }

  /// Add workspace to recent list (legacy method)
  Future<void> addRecentWorkspace(String workspacePath) async {
    // Delegate to openDirectoryTree for full functionality
    await openDirectoryTree(workspacePath);
  }

  /// Remove workspace from recent list
  Future<void> removeRecentWorkspace(String workspacePath) async {
    if (workspacePath.isEmpty) {
      return;
    }

    final currentWorkspaces = state is WorkspaceStateWithWorkspaces
        ? (state as WorkspaceStateWithWorkspaces).workspaces
        : <RecentWorkspace>[];
    emit(WorkspaceLoading(currentWorkspaces));

    final result = await codeCombinerUseCase.removeRecentWorkspace(workspacePath);

    result.fold(
      (failure) => emit(WorkspaceError(failure)),
      (updatedWorkspaces) {
        emit(const SuccessState('Workspace removed from recent list'));
        emit(WorkspaceLoaded(updatedWorkspaces));
      },
    );
  }

  /// Clear all recent workspaces
  Future<void> clearRecentWorkspaces() async {
    final currentWorkspaces = state is WorkspaceStateWithWorkspaces
        ? (state as WorkspaceStateWithWorkspaces).workspaces
        : <RecentWorkspace>[];
    emit(WorkspaceLoading(currentWorkspaces));

    final result = await codeCombinerUseCase.clearRecentWorkspaces();

    result.fold(
      (failure) => emit(WorkspaceError(failure)),
      (emptyList) {
        emit(const SuccessState('All recent workspaces cleared'));
        emit(WorkspaceLoaded(emptyList));
      },
    );
  }

  /// Toggle workspace favorite status (if implemented in models)
  Future<void> toggleWorkspaceFavorite(String workspacePath) async {
    if (workspacePath.isEmpty) {
      return;
    }

    final currentWorkspaces = state is WorkspaceStateWithWorkspaces
        ? (state as WorkspaceStateWithWorkspaces).workspaces
        : <RecentWorkspace>[];
    emit(WorkspaceLoading(currentWorkspaces));

    final result = await codeCombinerUseCase.toggleFavoriteRecentWorkspace(workspacePath);

    result.fold(
      (failure) => emit(WorkspaceError(failure)),
      (updatedWorkspaces) {
        emit(const SuccessState('Favorite toggled'));
        emit(WorkspaceLoaded(updatedWorkspaces));
      },
    );
  }

  /// Validate workspace path exists and is accessible
  Future<bool> validateWorkspace(String workspacePath) async {
    if (workspacePath.isEmpty) {
      return false;
    }

    // Use file content read as validation (if path is accessible, it should work)
    final result = await codeCombinerUseCase.readFileContent(workspacePath);

    return result.fold(
      (failure) => false, // Path is not accessible
      (content) => true, // Path is accessible
    );
  }

  /// Clean up invalid workspaces from recent list
  Future<void> cleanupInvalidWorkspaces() async {
    final currentWorkspaces = state is WorkspaceStateWithWorkspaces
        ? (state as WorkspaceStateWithWorkspaces).workspaces
        : <RecentWorkspace>[];
    emit(WorkspaceLoading(currentWorkspaces));

    // Get current workspaces
    final getResult = await codeCombinerUseCase.getRecentWorkspaces();

    await getResult.fold(
      (failure) async => emit(WorkspaceError(failure)),
      (workspaces) async {
        // Validate each workspace and remove invalid ones
        final validWorkspaces = <String>[];

        for (final workspace in workspaces) {
          final isValid = await validateWorkspace(workspace.path);
          if (isValid) {
            validWorkspaces.add(workspace.path);
          }
        }

        // If some workspaces were invalid, we need to rebuild the list
        if (validWorkspaces.length != workspaces.length) {
          // Clear all first
          await codeCombinerUseCase.clearRecentWorkspaces();

          // Add back only valid ones
          for (final path in validWorkspaces) {
            await codeCombinerUseCase.openDirectoryTree(
              path,
            ); // This adds workspace to recent
          }

          emit(const SuccessState('Invalid workspaces cleaned up'));
        } else {
          emit(const SuccessState('All workspaces are valid'));
        }

        // Reload to show final state
        unawaited(loadRecentWorkspaces());
      },
    );
  }

  /// Refresh workspace list
  Future<void> refresh() async {
    await loadRecentWorkspaces();
  }
}
