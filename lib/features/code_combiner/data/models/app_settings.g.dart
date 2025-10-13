// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      fileSplitSizeInMB: (json['fileSplitSizeInMB'] as num).toInt(),
      maxTokenWarningLimit: (json['maxTokenWarningLimit'] as num).toInt(),
      warnOnTokenExceed: json['warnOnTokenExceed'] as bool,
      stripCommentsFromCode: json['stripCommentsFromCode'] as bool,
      defaultExportLocation: json['defaultExportLocation'] as String?,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'fileSplitSizeInMB': instance.fileSplitSizeInMB,
      'maxTokenWarningLimit': instance.maxTokenWarningLimit,
      'warnOnTokenExceed': instance.warnOnTokenExceed,
      'stripCommentsFromCode': instance.stripCommentsFromCode,
      'defaultExportLocation': instance.defaultExportLocation,
    };
