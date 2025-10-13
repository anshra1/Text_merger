import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    required int maxTokenCount,
    required bool stripComments,
    required bool warnOnTokenLimit,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  factory SettingsModel.defaults() {
    return const SettingsModel(
      maxTokenCount: 8000,
      stripComments: false,
      warnOnTokenLimit: true,
    );
  }
}