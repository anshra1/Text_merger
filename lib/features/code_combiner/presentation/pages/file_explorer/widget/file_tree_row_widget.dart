import 'package:flutter/material.dart';
import 'package:material_design_system/theme/md_theme.dart';
import 'package:text_merger/features/code_combiner/data/enum/node_type.dart';

/// Private helper widget to render a single row in the tree.
class FileTreeRowWidget extends StatelessWidget {
  const FileTreeRowWidget({
    required this.node,
    required this.depth,
    required this.isExpanded,
    required this.isSelected,
    required this.onExpansionChanged,
    required this.onSelectionChanged,
    required this.label,
    super.key,
  });

  final NodeType node;
  final int depth;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onExpansionChanged;
  final VoidCallback onSelectionChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final md = MdTheme.of(context);
    final indentation = md.space.large(context) * depth;
    final isFolder = node == NodeType.folder;

    final rowColor = isSelected
        ? WidgetStateProperty.all(md.sys.surfaceContainerHigh)
        : null;

    final textStyle = md.typ
        .getBodyMedium(context)
        .copyWith(
          color: md.sys.onSurface,
        );

    return InkWell(
      onTap: isFolder ? onExpansionChanged : onSelectionChanged,
      borderRadius: md.sha.borderRadiusSmall,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: rowColor?.resolve({}),
            //   borderRadius: md.sha.borderRadiusSmall,
          ),
          padding: EdgeInsets.only(
            left: indentation,
            top: md.space.extraSmall(context),
            bottom: md.space.extraSmall(context),
            right: md.space.small(context),
          ),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: isSelected,
                onChanged: (_) => onSelectionChanged(),
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: md.sys.outline),
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return md.sys.primary;
                  }
                  return null; // Default
                }),
              ),
              // Spacer
              SizedBox(width: md.space.small(context)),
              // Expand/Collapse Chevron
              SizedBox(
                width: md.space.large(context),
                child: isFolder
                    ? Icon(
                        isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                        color: md.sys.onSurfaceVariant,
                      )
                    : null,
              ),
              // File/Folder Icon
              Icon(
                isFolder ? Icons.folder : Icons.article_outlined,
                color: isFolder ? md.sys.tertiary : md.sys.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: md.space.small(context)),
              // Label
              Expanded(
                child: Text(
                  label,
                  style: textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
