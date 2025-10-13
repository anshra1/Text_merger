import 'dart:io';

import 'package:flutter/material.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';

class RecentWorkspaceCard extends StatelessWidget {
  const RecentWorkspaceCard({
    required this.workspace,
    required this.onOpen,
    required this.onToggleFavorite,
    required this.onRemove,
    this.isLoading = false,
    super.key,
  });

  final RecentWorkspace workspace;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;
  final VoidCallback onRemove;
  final bool isLoading;

  String _basename(String path) => path.split(Platform.pathSeparator).last;
  String _dirname(String path) {
    final sep = Platform.pathSeparator;
    final idx = path.lastIndexOf(sep);
    return idx > 0 ? path.substring(0, idx) : path;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final title = _basename(workspace.path);
    final subtitle = _dirname(workspace.path);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onOpen,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.folder,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'favorite':
                            onToggleFavorite();
                          case 'remove':
                            onRemove();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'favorite',
                          child: Row(
                            children: [
                              Icon(
                                workspace.isFavorite ? Icons.star : Icons.star_border,
                                color: workspace.isFavorite ? colorScheme.tertiary : null,
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
                      child: Icon(
                        Icons.more_vert,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatLastAccessed(workspace.lastAccessed),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
