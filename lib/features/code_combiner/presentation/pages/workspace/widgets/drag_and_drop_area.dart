import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_system/theme/md_theme.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/workspace_cubit.dart';

class FolderDropCopyPath extends StatefulWidget {
  const FolderDropCopyPath({super.key});

  @override
  State<FolderDropCopyPath> createState() => _FolderDropCopyPathState();
}

class _FolderDropCopyPathState extends State<FolderDropCopyPath> {
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final md = MdTheme.of(context);
    return Center(
      child: DropRegion(
        formats: const [Formats.fileUri],
        hitTestBehavior: HitTestBehavior.opaque,
        onDropOver: (event) {
          // This drop region only supports copy operation.
          if (event.session.allowedOperations.contains(DropOperation.copy)) {
            return DropOperation.copy;
          } else {
            return DropOperation.none;
          }
        },
        onDropEnter: (event) {
          setState(() {
            _isDragOver = true;
          });
        },
        onDropLeave: (event) {
          setState(() {
            _isDragOver = false;
          });
        },
        onPerformDrop: (event) async {
          setState(() {
            _isDragOver = false; // Reset drag over state
          });
          for (final item in event.session.items) {
            final reader = item.dataReader;
            if (reader != null && reader.canProvide(Formats.uri)) {
              reader.getValue<NamedUri>(
                Formats.uri,
                (namedUri) async {
                  if (namedUri != null) {
                    final path = namedUri.uri.toFilePath();
                    if (FileSystemEntity.isDirectorySync(path)) {
                      debugPrint('✅ Dropped folder path: $path');
                      if (mounted) {
                        await context.read<WorkspaceCubit>().openDirectoryTree(path);
                      }
                    } else {
                      debugPrint('❌ Dropped item is not a folder: $path');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please drop a folder, not a file.'),
                          ),
                        );
                      }
                    }
                  }
                },
                onError: (error) {
                  debugPrint('Error reading value: $error');
                },
              );
            }
          }
        },
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          color: _isDragOver ? md.sys.primary : md.sys.outlineVariant,
          strokeWidth: 2,
          dashPattern: const [8, 4],
          padding: EdgeInsets.zero,
          child: Container(
            alignment: Alignment.center,
            constraints: const BoxConstraints(
              minHeight: 200,
            ),
            decoration: BoxDecoration(
              color: _isDragOver
                  ? md.sys.primaryContainer
                  : md.sys.surfaceVariant.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: _isDragOver ? md.sys.primary : md.sys.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Drag & Drop Folder Here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _isDragOver ? md.sys.primary : md.sys.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Supports any standard workspace directory',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: md.sys.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
