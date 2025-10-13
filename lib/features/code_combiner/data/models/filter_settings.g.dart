// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilterSettingsImpl _$$FilterSettingsImplFromJson(Map<String, dynamic> json) =>
    _$FilterSettingsImpl(
      blockedExtensions: (json['blockedExtensions'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      blockedFilePaths: (json['blockedFilePaths'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      blockedFileNames: (json['blockedFileNames'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      blockedFolderNames: (json['blockedFolderNames'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      maxFileSizeInMB: (json['maxFileSizeInMB'] as num).toInt(),
      includeHiddenFiles: json['includeHiddenFiles'] as bool,
      allowedExtensions: (json['allowedExtensions'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      searchQuery: json['searchQuery'] as String?,
    );

Map<String, dynamic> _$$FilterSettingsImplToJson(
        _$FilterSettingsImpl instance) =>
    <String, dynamic>{
      'blockedExtensions': instance.blockedExtensions.toList(),
      'blockedFilePaths': instance.blockedFilePaths.toList(),
      'blockedFileNames': instance.blockedFileNames.toList(),
      'blockedFolderNames': instance.blockedFolderNames.toList(),
      'maxFileSizeInMB': instance.maxFileSizeInMB,
      'includeHiddenFiles': instance.includeHiddenFiles,
      'allowedExtensions': instance.allowedExtensions.toList(),
      'searchQuery': instance.searchQuery,
    };
