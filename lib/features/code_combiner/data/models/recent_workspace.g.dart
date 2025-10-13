// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecentWorkspaceImpl _$$RecentWorkspaceImplFromJson(
        Map<String, dynamic> json) =>
    _$RecentWorkspaceImpl(
      path: json['path'] as String,
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
      isFavorite: json['isFavorite'] as bool,
    );

Map<String, dynamic> _$$RecentWorkspaceImplToJson(
        _$RecentWorkspaceImpl instance) =>
    <String, dynamic>{
      'path': instance.path,
      'lastAccessed': instance.lastAccessed.toIso8601String(),
      'isFavorite': instance.isFavorite,
    };
