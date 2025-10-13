//
// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_merger/features/code_combiner/data/models/settings_model.dart';
import 'package:text_merger/features/code_combiner/presentation/pages/settings/cubit/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required this.prefs}) : super(SettingsState.initial());

  final SharedPreferences prefs;
  static const _settingsKey = 'general_settings';

  Future<void> init() async {
    await _loadSettings();
  }

  void updateMaxTokenCount(String count) {
    final newCount = int.tryParse(count) ?? 0;
    emit(state.copyWith(settings: state.settings.copyWith(maxTokenCount: newCount)));
    _saveSettings();
  }

  void toggleStripComments(bool value) {
    emit(state.copyWith(settings: state.settings.copyWith(stripComments: value)));
    _saveSettings();
  }

  void toggleWarnOnTokenLimit(bool value) {
    emit(state.copyWith(settings: state.settings.copyWith(warnOnTokenLimit: value)));
    _saveSettings();
  }

  void resetToDefaults() {
    emit(state.copyWith(settings: SettingsModel.defaults()));
    _saveSettings();
  }

  Future<void> _loadSettings() async {
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString != null) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final settings = SettingsModel.fromJson(json);
      emit(state.copyWith(settings: settings));
    }
  }

  Future<void> _saveSettings() async {
    final json = state.settings.toJson();
    await prefs.setString(_settingsKey, jsonEncode(json));
  }
}
