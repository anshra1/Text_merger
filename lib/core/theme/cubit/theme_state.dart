import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  const ThemeState({
    required this.themeMode,
    required this.fontFamily,
    required this.platformBrightness,
    required this.isLoading,
    this.errorMessage,
  });

  const ThemeState.initial()
      : themeMode = ThemeMode.light,
        fontFamily = '',
        platformBrightness = Brightness.light,
        isLoading = false,
        errorMessage = null;

  final ThemeMode themeMode;
  final String fontFamily;
  final Brightness platformBrightness;
  final bool isLoading;
  final String? errorMessage;

  ThemeState copyWith({
    ThemeMode? themeMode,
    String? fontFamily,
    Brightness? platformBrightness,
    bool? isLoading,
    String? errorMessage,
  }) =>
      ThemeState(
        themeMode: themeMode ?? this.themeMode,
        fontFamily: fontFamily ?? this.fontFamily,
        platformBrightness: platformBrightness ?? this.platformBrightness,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        themeMode,
        fontFamily,
        platformBrightness,
        isLoading,
        errorMessage,
      ];
}
