// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsModelImpl _$$SettingsModelImplFromJson(Map<String, dynamic> json) =>
    _$SettingsModelImpl(
      maxTokenCount: (json['maxTokenCount'] as num).toInt(),
      stripComments: json['stripComments'] as bool,
      warnOnTokenLimit: json['warnOnTokenLimit'] as bool,
    );

Map<String, dynamic> _$$SettingsModelImplToJson(_$SettingsModelImpl instance) =>
    <String, dynamic>{
      'maxTokenCount': instance.maxTokenCount,
      'stripComments': instance.stripComments,
      'warnOnTokenLimit': instance.warnOnTokenLimit,
    };
