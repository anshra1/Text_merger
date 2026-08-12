import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/workspace_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/workspace/widgets/drag_and_drop_area.dart';

class WorkspaceSelectorPage extends StatelessWidget {
  const WorkspaceSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.dashboard_customize_rounded,
                            size: 64,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Welcome to Text Merger',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Open a directory to start combining your code into a single context file for AI.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        
                        SizedBox(
                          width: 320,
                          height: 56,
                          child: FilledButton.icon(
                            onPressed: () async {
                              final path = await _pickDirectoryWithSystemDialog();
                              if (path != null && context.mounted) {
                                await context.read<WorkspaceCubit>().openDirectoryTree(path);
                              }
                            },
                            style: FilledButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            icon: const Icon(Icons.folder_open_rounded, size: 24),
                            label: const Text(
                              'Select a Directory',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        const Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        const SizedBox(
                          width: 500,
                          child: FolderDropCopyPath(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    return null;
  }
}
