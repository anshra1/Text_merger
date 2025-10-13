import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_workspace.freezed.dart';
part 'recent_workspace.g.dart';

@freezed
class RecentWorkspace with _$RecentWorkspace {
  const factory RecentWorkspace({
    required String path,
    required DateTime lastAccessed,
    required bool isFavorite,
  }) = _RecentWorkspace;

  factory RecentWorkspace.fromJson(Map<String, dynamic> json) =>
      _$RecentWorkspaceFromJson(json);

  const RecentWorkspace._();
}
