import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_system/material_design_system.dart';
import 'package:text_merger/core/theme/cubit/sidebar_cubit.dart';
import 'package:text_merger/features/code_combiner/data/enum/node_type.dart';
import 'package:text_merger/features/code_combiner/data/models/file_node.dart';
import 'package:text_merger/features/code_combiner/domain/repositories/code_combiner_repository.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/file_explorer_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/file_explorer_state.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/file_explorer/view/file_tree_view.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/file_explorer/widget/filter_input.dart';
import 'package:toastification/toastification.dart';

class FileExplorerPage extends StatefulWidget {
  const FileExplorerPage({required this.workspaceData, super.key});

  final Object workspaceData;

  @override
  State<FileExplorerPage> createState() => _FileExplorerPageState();
}

class _FileExplorerPageState extends State<FileExplorerPage> {
  @override
  void initState() {
    super.initState();
    _initWorkspace(widget.workspaceData);
  }

  @override
  void didUpdateWidget(covariant FileExplorerPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.workspaceData != widget.workspaceData) {
      _initWorkspace(widget.workspaceData);
    }
  }

  void _initWorkspace(Object data) {
    final cubit = context.read<FileExplorerCubit>();
    if (data is WorkspaceData) {
      cubit.initializeFromWorkspaceData(data);
    } else if (data is String) {
      cubit.initialize(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = MdTheme.of(context).space;

    WidgetsBinding.instance.addPostFrameCallback((_) {});

    return BlocConsumer<FileExplorerCubit, FileExplorerState>(
      listener: (context, state) {
        if (state is FileExplorerTimeout) {
          _showTimeoutDialog(context, state);
        }
        if (state is FileExplorerError) {
          toastification.show(
            context: context,
            title: const Text(
              'Error',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,

              ),
            ),
            description: Text(
              state.message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 5),
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is FileExplorerLoading;
        final nodes = switch (state) {
          final FileExplorerLoaded s => s.filteredNodes,
          final FileExplorerFilterUpdating s => s.filteredNodes,
          final FileExplorerFilterUpdateSuccess s => s.filteredNodes,
          _ => <String, FileNode>{},
        };

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _handleSaveAs(context),
            icon: const Icon(Icons.save_alt_outlined),
            label: const Text('Save As'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Custom header with same background as AppBar
              ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      BlocBuilder<SidebarCubit, bool>(
                        builder: (context, isOpen) {
                          return IconButton(
                            icon: Icon(isOpen ? Icons.menu_open : Icons.menu),
                            onPressed: () => context.read<SidebarCubit>().toggle(),
                            tooltip: isOpen ? 'Close Sidebar' : 'Open Sidebar',
                          );
                        }
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.folder_open_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'File Explorer',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${nodes.values.where((n) => n.type == NodeType.file).length} files selected',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              // Main content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(spacing.large(context)),
                  child: Column(
                    children: [
                      // Filters section
                      SizedBox(height: spacing.small(context)),
                      FilterInput(
                        onChanged: (filters) {
                          context.read<FileExplorerCubit>().applyPositiveFilters(
                            filters.toSet(),
                          );
                        },
                        onSearchChanged: (query) {
                          context.read<FileExplorerCubit>().applySearchQuery(query);
                        },
                      ),

                      SizedBox(height: spacing.small(context)),

                      Expanded(
                        child: DecoratedBox(
                          decoration: const BoxDecoration(),
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : TreeView(nodes: nodes),
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

  Future<void> _handleSaveAs(BuildContext context) async {
    // Get app settings for default location
    final cubit = context.read<FileExplorerCubit>();

    // Show file picker save dialog
    final savePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Text Merger File',
      fileName: 'text_merger_${DateTime.now().millisecondsSinceEpoch}.txt',
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (savePath == null) {
      // User cancelled
      if (!context.mounted) return;
      toastification.show(
        context: context,
        title: const Text(
          'Save Cancelled',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        description: const Text(
          'File save operation was cancelled',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        type: ToastificationType.warning,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      );
      return;
    }

    // Export with custom path
    final exportPreview = await cubit.exportSelectedFiles(savePath: savePath);

    if (!context.mounted) return;

    if (exportPreview != null && exportPreview.successedReturnedFiles.isNotEmpty) {
      final savedFile = exportPreview.successedReturnedFiles.first;
      final fileName = savedFile.path.split(Platform.pathSeparator).last;
      final fileLocation = savedFile.parent.path;

      toastification.show(
        context: context,
        title: const Text(
          'File Saved Successfully',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        description: Text(
          '$fileName\nLocation: $fileLocation',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 5),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      );
    }
  }

  void _showTimeoutDialog(BuildContext context, FileExplorerTimeout state) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text('Folder Too Large'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This folder contains too many files to process quickly.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.folder,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.folderPath.split(Platform.pathSeparator).last,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Files found: ${state.fileCount}+',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Path: ${state.folderPath}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please try one of these options:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            _buildSuggestion(
              context,
              Icons.folder_open,
              'Select a smaller folder',
              'Choose a subfolder with fewer files',
            ),
            const SizedBox(height: 8),
            _buildSuggestion(
              context,
              Icons.refresh,
              'Try again',
              'The folder might load faster on retry',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop(); // Return to workspace page
            },
            child: const Text('Go Back'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Retry with the same folder
              context.read<FileExplorerCubit>().initialize(state.folderPath);
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestion(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
