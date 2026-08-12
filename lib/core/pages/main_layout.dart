import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:text_merger/core/routes/route_name.dart';
import 'package:text_merger/core/theme/cubit/sidebar_cubit.dart';
import 'package:text_merger/core/theme/cubit/theme_cubit.dart';
import 'package:text_merger/core/theme/cubit/theme_state.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/workspace_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/workspace_state.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({required this.child, super.key});

  final Widget child;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  void initState() {
    super.initState();
    context.read<WorkspaceCubit>().loadRecentWorkspaces();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  
    
    return BlocListener<WorkspaceCubit, WorkspaceState>(
      listener: (context, state) {
        if (state is WorkspaceOpened) {
          context.read<SidebarCubit>().hide(); // Auto-close sidebar
          context.goNamed(RoutesName.fileExplorer, extra: state.workspaceData);
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Stack(
          children: [
            Row(
              children: [
          // Sidebar
          BlocBuilder<SidebarCubit, bool>(
            builder: (context, isSidebarOpen) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                width: isSidebarOpen ? 280 : 0,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  border: Border(
                    right: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    width: 280,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                // App Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Icon(
                        Icons.merge_type_rounded,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Text Merger',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Open Folder Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FilledButton.icon(
                    onPressed: () async {
                      try {
                        final directoryPath = await FilePicker.platform.getDirectoryPath(
                          dialogTitle: 'Select Workspace Directory',
                        );
                        if (directoryPath != null && context.mounted) {
                          await context.read<WorkspaceCubit>().openDirectoryTree(directoryPath);
                        }
                      } on Exception catch (_) {
                        // ignore
                      }
                    },
                    icon: const Icon(Icons.folder_open_rounded, size: 18),
                    label: const Text('Open Directory'),
                    style: FilledButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Recent Workspaces Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'RECENT WORKSPACES',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                
                // Recent Workspaces List
                Expanded(
                  child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
                    builder: (context, state) {
                      final workspaces = state is WorkspaceStateWithWorkspaces
                          ? state.workspaces
                          : <RecentWorkspace>[];
                          
                      if (workspaces.isEmpty) {
                        return Center(
                          child: Text(
                            'No recent workspaces',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      }
                      
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: workspaces.length,
                        itemBuilder: (context, index) {
                          final workspace = workspaces[index];
                          final isSelected = state is WorkspaceOpened && state.workspaceData.workspacePath == workspace.path;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Material(
                              color: isSelected 
                                  ? theme.colorScheme.primaryContainer 
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  context.read<WorkspaceCubit>().openDirectoryTree(workspace.path);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected ? Icons.folder : Icons.folder_outlined, 
                                        size: 16,
                                        color: isSelected 
                                            ? theme.colorScheme.onPrimaryContainer
                                            : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          workspace.path.split(RegExp(r'[\\/]')).last,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            color: isSelected
                                                ? theme.colorScheme.onPrimaryContainer
                                                : theme.colorScheme.onSurfaceVariant,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                
                // Bottom Settings/Theme row
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pushNamed(RoutesName.settings),
                        icon: const Icon(Icons.settings_outlined),
                        tooltip: 'Settings',
                      ),
                      const Spacer(),
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, themeState) {
                          final isDark = themeState.themeMode == ThemeMode.dark;
                          return IconButton(
                            onPressed: () => context.read<ThemeCubit>().toggleThemeMode(),
                            icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                            tooltip: 'Toggle Theme',
                          );
                        },
                      ),
                    ],
                  ),
                ),
                    ],
                  ),
                  ),
                ),
              );
            }
          ),
          
          // Main Content Area
          Expanded(
            child: ClipRect(
              child: widget.child,
            ),
          ),
        ],
      ),
      
      // Loading Overlay
      BlocBuilder<WorkspaceCubit, WorkspaceState>(
        builder: (context, state) {
          if (state is WorkspaceLoading) {
            return Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 32,
                            offset: const Offset(0, 16),
                          ),
                        ],
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: theme.colorScheme.primary,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            state.scannedCount > 0
                                ? 'Scanning... ${state.scannedCount} files read'
                                : 'Opening workspace...',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This might take a moment for large directories',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 32),
                          FilledButton.tonalIcon(
                            onPressed: () {
                              context.read<WorkspaceCubit>().cancelLoading();
                            },
                            icon: const Icon(Icons.close_rounded, size: 18),
                            label: const Text('Cancel'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ],
  ),
),
    );
  }
}
