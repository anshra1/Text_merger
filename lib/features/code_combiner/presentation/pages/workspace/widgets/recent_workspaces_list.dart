import 'dart:io';

import 'package:flutter/material.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/workspace/widgets/recent_workspace_card.dart';
import 'package:text_merger/features/code_combiner/presentation/widgets/empty_state_widget.dart';

enum ViewMode { list, grid }

class RecentWorkspacesList extends StatefulWidget {
  const RecentWorkspacesList({
    required this.workspaces,
    required this.onOpen,
    required this.onToggleFavorite,
    required this.onRemove,
    this.loadingPath,
    super.key,
  });

  final List<RecentWorkspace> workspaces;
  final void Function(String path) onOpen;
  final void Function(String path) onToggleFavorite;
  final void Function(String path) onRemove;
  final String? loadingPath;

  @override
  State<RecentWorkspacesList> createState() => _RecentWorkspacesListState();
}

class _RecentWorkspacesListState extends State<RecentWorkspacesList> {
  ViewMode _viewMode = ViewMode.grid;

  @override
  Widget build(BuildContext context) {
    if (widget.workspaces.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history,
        title: 'No recent workspaces',
        subtitle: 'Open a folder to get started',
      );
    }

    return Column(
      children: [
        // View toggle header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Workspaces',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SegmentedButton<ViewMode>(
                segments: const [
                  ButtonSegment<ViewMode>(
                    value: ViewMode.list,
                    icon: Icon(Icons.list),
                    label: Text('List'),
                  ),
                  ButtonSegment<ViewMode>(
                    value: ViewMode.grid,
                    icon: Icon(Icons.grid_view),
                    label: Text('Grid'),
                  ),
                ],
                selected: {_viewMode},
                onSelectionChanged: (Set<ViewMode> selection) {
                  setState(() {
                    _viewMode = selection.first;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Content based on view mode
        if (_viewMode == ViewMode.list) _buildListView() else _buildGridView(),
      ],
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SingleChildScrollView(
        child: Column(
          children: widget.workspaces.map((workspace) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.folder,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    workspace.path.split(Platform.pathSeparator).last,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workspace.path,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatLastAccessed(workspace.lastAccessed),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (workspace.isFavorite)
                        Icon(
                          Icons.star,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'open':
                              widget.onOpen(workspace.path);
                            case 'favorite':
                              widget.onToggleFavorite(workspace.path);
                            case 'remove':
                              widget.onRemove(workspace.path);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'open',
                            child: Row(
                              children: [
                                Icon(Icons.folder_open, size: 20),
                                SizedBox(width: 8),
                                Text('Open'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'favorite',
                            child: Row(
                              children: [
                                Icon(
                                  workspace.isFavorite ? Icons.star : Icons.star_border,
                                  color: workspace.isFavorite
                                      ? Theme.of(context).colorScheme.tertiary
                                      : null,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(workspace.isFavorite ? 'Unfavorite' : 'Favorite'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'remove',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, size: 20),
                                SizedBox(width: 8),
                                Text('Remove'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => widget.onOpen(workspace.path),
                  isThreeLine: true,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid: cap tile width to maintain readability
        const maxTileWidth = 360.0;
        final crossAxisCount = (constraints.maxWidth / maxTileWidth).clamp(1, 6).floor();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 16 / 8,
              ),
              itemCount: widget.workspaces.length,
              itemBuilder: (context, index) {
                final ws = widget.workspaces[index];
                return RecentWorkspaceCard(
                  workspace: ws,
                  isLoading: widget.loadingPath == ws.path,
                  onOpen: () => widget.onOpen(ws.path),
                  onToggleFavorite: () => widget.onToggleFavorite(ws.path),
                  onRemove: () => widget.onRemove(ws.path),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _formatLastAccessed(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    // Fallback to date string
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
