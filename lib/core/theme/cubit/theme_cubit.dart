// appearance_cubit.dart
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_merger/core/theme/cubit/theme_state.dart';

/// Minimal cubit that handles:
///   - theme mode (light / dark / system)
///   - font family override
///   - persistence via SharedPreferences
///   - live reaction to OS brightness changes when ThemeMode.system
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState.initial()) {
    _setupPlatformBrightnessListener();
  }

  static const _settingsKey = 'appearance_settings_minimal';
  Timer? _saveTimer;
  late final SharedPreferences _prefs;

  /// Must be called once after instantiation.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
  }

  /// Sets and persists the theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    _saveSettingsDebounced();
  }

  /// Toggles between light and dark.
  void toggleThemeMode() =>
      setThemeMode(state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);

  /// Sets and persists the custom font family.
  Future<void> setFontFamily(String font) async {
    emit(state.copyWith(fontFamily: font));
    _saveSettingsDebounced();
  }

  /// Resets to the empty string (use theme default).
  Future<void> resetFontFamily() => setFontFamily('');

  /* ---------------- OS brightness listener ---------------- */

  void _setupPlatformBrightnessListener() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      if (state.themeMode == ThemeMode.system) {
        final newBrightness = PlatformDispatcher.instance.platformBrightness;
        emit(state.copyWith(platformBrightness: newBrightness));
        _saveSettingsDebounced();
      }
    };
  }

  /* ---------------- lifecycle ---------------- */

  @override
  Future<void> close() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = null;
    _saveTimer?.cancel();
    return super.close();
  }

  /* ---------------- persistence helpers ---------------- */

  Future<void> _loadSettings() async {
    try {
      final json = _prefs.getString(_settingsKey);
      if (json == null) return;
      final map = jsonDecode(json) as Map<String, dynamic>;
      emit(
        state.copyWith(
          themeMode: ThemeMode.values.firstWhere(
            (e) => e.name == map['themeMode'],
            orElse: () => ThemeMode.light,
          ),
          fontFamily: (map['fontFamily'] as String?) ?? '',
        ),
      );
    } on Exception catch (_) {
      // ignore silently
    }
  }

  void _saveSettingsDebounced() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), _saveSettings);
  }

  Future<void> _saveSettings() async {
    try {
      final map = {
        'themeMode': state.themeMode.name,
        'fontFamily': state.fontFamily,
      };
      await _prefs.setString(_settingsKey, jsonEncode(map));
    } on Exception catch (_) {
      // ignore silently
    }
  }
}
