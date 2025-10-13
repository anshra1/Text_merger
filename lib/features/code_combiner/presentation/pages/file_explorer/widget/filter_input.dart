// lib/widgets/filter_input.dart

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:material_design_system/theme/md_theme.dart';

/// A widget that allows users to input text and manage a list of filter chips.
///
/// This is a "Controlled Widget". It is stateless and relies on the parent
// ignore: comment_references
/// to provide the list of [filters] and an [onChanged] callback to signal
/// when the list should be updated.
class FilterInput extends HookWidget {
  /// Creates a filter input widget.
  const FilterInput({
    required this.onChanged,
    this.onSearchChanged,
    super.key,
    this.hintText = 'Search files or add extension filter (e.g., .dart)',
    this.addButtonChild = const Text('Add Filter'),
  });

  /// A callback that provides the updated list when a filter is added or removed.
  /// The parent widget is responsible for updating its state with this new list.
  final ValueChanged<List<String>> onChanged;

  /// A callback that provides the updated search query as the user types.
  final ValueChanged<String>? onSearchChanged;

  /// The hint text to display in the text field.
  final String hintText;

  /// The widget to display inside the "Add Filter" button.
  final Widget addButtonChild;

  @override
  Widget build(BuildContext context) {
    final md = MdTheme.of(context);
    final filters = useState<List<String>>([]);
    final textController = useTextEditingController();
    final focusNode = useFocusNode();

    void addFilter() {
      final text = textController.text.trim();
      if (text.isEmpty || filters.value.contains(text)) {
        return;
      }

      final newList = [...filters.value, text];
      filters.value = newList;
      onChanged(newList);
      textController.clear();
      focusNode.requestFocus();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                focusNode: focusNode,
                style: md.com.textField.textStyle,
                onChanged: onSearchChanged,
                onSubmitted: (_) => addFilter(),
                onEditingComplete: addFilter,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: md.com.textField.backgroundColor,
                  hintText: hintText,
                  hintStyle: md.com.textField.labelStyle,
                  border: OutlineInputBorder(
                    borderRadius: md.sha.borderRadiusSmall,
                    borderSide: BorderSide(color: md.sys.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: md.sha.borderRadiusSmall,
                    borderSide: BorderSide(color: md.sys.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: md.sha.borderRadiusSmall,
                    borderSide: BorderSide(color: md.sys.primary, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: md.space.medium(context),
                    vertical: md.space.small(context),
                  ),
                ),
              ),
            ),
            SizedBox(width: md.space.small(context)),
            ElevatedButton(
              onPressed: addFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: md.com.button.elevatedButtonBackgroundColor,
                foregroundColor: md.com.button.elevatedButtonForegroundColor,
                textStyle: md.com.button.textStyle,
                shape: md.sha.shapeSmall as OutlinedBorder?,
                padding: EdgeInsets.symmetric(
                  horizontal: md.space.medium(context),
                  vertical: md.space.medium(context) - 2,
                ),
              ),
              child: addButtonChild,
            ),
          ],
        ),
        SizedBox(height: md.space.medium(context)),
        if (filters.value.isNotEmpty)
          Wrap(
            spacing: md.space.small(context),
            runSpacing: md.space.small(context),
            children: filters.value.map((filter) {
              return InputChip(
                label: Text(filter),
                labelStyle: md.com.chip.labelStyle,
                backgroundColor: md.com.chip.backgroundColor,
                onDeleted: () {
                  final newList = List<String>.from(filters.value)..remove(filter);
                  onChanged(newList);
                  filters.value = newList;
                },
                deleteIconColor: md.sys.onSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: md.sha.borderRadiusSmall,
                  side: BorderSide(color: md.sys.outline),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
