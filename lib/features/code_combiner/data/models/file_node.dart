import 'package:text_merger/features/code_combiner/data/enum/node_type.dart';
import 'package:text_merger/features/code_combiner/data/enum/selection_state.dart';

class FileNode {
  FileNode({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.selectionState,
    required this.isExpanded,
    required this.childIds,
    this.parentId,
  });


  
  final String id;
  final String name;
  final String path;
  final NodeType type;
  final SelectionState selectionState;
  final bool isExpanded;
  final String? parentId;
  final List<String> childIds;

  FileNode copyWith({
    String? id,
    String? name,
    String? path,
    NodeType? type,
    SelectionState? selectionState,
    bool? isExpanded,
    String? parentId,
    List<String>? childIds,
  }) {
    return FileNode(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      type: type ?? this.type,
      selectionState: selectionState ?? this.selectionState,
      isExpanded: isExpanded ?? this.isExpanded,
      parentId: parentId ?? this.parentId,
      childIds: childIds ?? this.childIds,
    );
  }
}
