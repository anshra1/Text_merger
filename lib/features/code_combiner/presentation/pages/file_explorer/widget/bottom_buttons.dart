import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_system/tokens/base_token/spacing_tokens.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/file_explorer_cubit.dart';

class BottonButtons extends StatelessWidget {
  const BottonButtons({
    required this.spacing,
    super.key,
  });

  final SpacingTokens spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => context.read<FileExplorerCubit>().exportSelectedFiles(),
          icon: const Icon(Icons.save_alt_outlined),
          label: const Text('Save As'),
        ),
      ],
    );
  }
}
