import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_system/theme/md_theme.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

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
                      await Clipboard.setData(ClipboardData(text: path));
                      debugPrint('✅ Copied folder path: $path');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied folder path: $path'),
                          ),
                        );
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
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 800,
            maxHeight: 200,
          ),
          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: _isDragOver
                ? md.sys.primaryContainer
                : md.sys.surfaceVariant.withOpacity(0.2),
            border: Border.all(
              color: _isDragOver ? md.sys.primary : md.sys.outlineVariant,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '⬇️ Drag & Drop Folder or File(s) Here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19.2, // Equivalent to 1.2em (16 * 1.2)
                  fontWeight: FontWeight.w500,
                  color: md.sys.primary, // Example primary color
                ),
              ),
              const SizedBox(height: 8), // spacing-unit
              const Text(
                '(Detects only valid directories with supported files — .dart, .ts, .java, etc.)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.4, // Equivalent to 0.9em (16 * 0.9)
                  color: Color(0xFF666666), // Example hint color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
