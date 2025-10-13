import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_system/material_design_system.dart';
import 'package:text_merger/core/routes/route_name.dart';
import 'package:text_merger/core/theme/cubit/theme_cubit.dart';
import 'package:text_merger/core/theme/cubit/theme_state.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/workspace_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/workspace_state.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/workspace/widgets/drag_and_drop_area.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/workspace/widgets/recent_workspaces_list.dart';

class WorkspaceSelectorPage extends StatefulWidget {
  const WorkspaceSelectorPage({super.key});

  @override
  State<WorkspaceSelectorPage> createState() => _WorkspaceSelectorPageState();
}

class _WorkspaceSelectorPageState extends State<WorkspaceSelectorPage> {
  @override
  void initState() {
    super.initState();

    context.read<WorkspaceCubit>().loadRecentWorkspaces();
  }

  @override
  Widget build(BuildContext context) {
    final md = MdTheme.of(context);
    final spacing = SpacingTokens();

    return BlocConsumer<WorkspaceCubit, WorkspaceState>(
      listener: (context, state) {
        if (state is WorkspaceError) {
          // _showNotImplementedSnack(
          //   context,
          //   '${state.failure.title}: ${state.failure.message}',
          // );
        }
        // Navigation occurs on selection to explorer with path
        if (state is SuccessState) {
          // Optional feedback messages
          // _showNotImplementedSnack(context, state.message);
        }

        if (state is WorkspaceOpened) {
          context.pushNamed(RoutesName.fileExplorer, extra: state.workspaceData);
        }
      },
      builder: (context, state) {
        final isLoading = state is WorkspaceLoading;
        // Preserve workspaces during loading to prevent UI flicker
        final workspaces = state is WorkspaceStateWithWorkspaces
            ? state.workspaces
            : <RecentWorkspace>[];

        return Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SizedBox(height: spacing.small(context)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: WorkspaceHeader(
                          title: 'Text Merger',
                          textStyle: md.typ
                              .getHeadlineLarge(context)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      SizedBox(height: spacing.large() * 2),
                      SizedBox(
                        width: 300,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final path = await _pickDirectoryWithSystemDialog();
                            if (path != null) {
                              if (!context.mounted) return;
                              await context.pushNamed(
                                RoutesName.fileExplorer,
                                extra: path,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                          icon: const Icon(Icons.folder_open, size: 24),
                          label: const Text(
                            'Select a Directory',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.large()),

                      const FolderDropCopyPath(),

                      SizedBox(height: spacing.large(context)),

                      RecentWorkspacesList(
                        workspaces: workspaces,
                        onOpen: (path) {
                          context.read<WorkspaceCubit>().openDirectoryTree(path);
                        },
                        onToggleFavorite: (path) {
                          context.read<WorkspaceCubit>().toggleWorkspaceFavorite(path);
                        },
                        onRemove: (path) {
                          context.read<WorkspaceCubit>().removeRecentWorkspace(path);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              // Theme toggle button in top-right corner
              Positioned(
                top: 16,
                right: 16,
                child: BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    return FloatingActionButton.small(
                      onPressed: () => context.read<ThemeCubit>().toggleThemeMode(),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      elevation: 0,
                      child: Icon(
                        themeState.themeMode == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                    );
                  },
                ),
              ),
              // Full-screen loading overlay
              if (isLoading)
                ColoredBox(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Opening workspace...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

Future<String?> _pickDirectoryWithSystemDialog() async {
  try {
    final directoryPath = await FilePicker.platform
        .getDirectoryPath(
          dialogTitle: 'Select Workspace Directory',
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => null,
        );
    return directoryPath;
  } on Exception catch (_) {
    // TODO: Handle unsupported platforms gracefully; fallback to manual prompt
    return null;
  }
}
