import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_merger/features/code_combiner/data/enum/node_type.dart';
import 'package:text_merger/features/code_combiner/data/models/file_node.dart';
import 'package:text_merger/features/code_combiner/presentation/cubits/file_explorer_cubit.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/file_explorer/widget/file_tree_row_widget.dart';

class TreeView extends StatelessWidget {
  const TreeView({required this.nodes, super.key});

  final Map<String, FileNode> nodes;

  @override
  Widget build(BuildContext context) {
    // Find root nodes (no parent or parent not present)
    final roots = nodes.values.where(
      (n) => n.parentId == null || !nodes.containsKey(n.parentId),
    );
    return ListView(
      children: roots.map((n) => TreeNode(node: n, nodes: nodes, depth: 0)).toList(),
    );
  }
}

class TreeNode extends StatelessWidget {
  const TreeNode({
    required this.node,
    required this.nodes,
    required this.depth,
    super.key,
  });

  final FileNode node;
  final Map<String, FileNode> nodes;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FileExplorerCubit>();
    final isFolder = node.type == NodeType.folder;
    final isExpanded = isFolder && cubit.isFolderExpanded(node.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FileTreeRowWidget(
          node: node.type,
          depth: depth,
          isExpanded: isExpanded,
          isSelected: node.selectionState.name == 'checked',
          onExpansionChanged: () => cubit.toggleFolderExpansion(node.id),
          onSelectionChanged: () => cubit.toggleNodeSelection(node.id),
          label: node.name,
        ),
        if (isFolder && isExpanded)
          ...node.childIds
              .map((id) => nodes[id])
              .whereType<FileNode>()
              .map((child) => TreeNode(node: child, nodes: nodes, depth: depth + 1)),
      ],
    );
  }
}
