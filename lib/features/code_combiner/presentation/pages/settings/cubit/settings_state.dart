import 'package:equatable/equatable.dart';
import 'package:text_merger/features/code_combiner/data/models/settings_model.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.settings,
  });

  factory SettingsState.initial() {
    return SettingsState(settings: SettingsModel.defaults());
  }

  final SettingsModel settings;

  SettingsState copyWith({
    SettingsModel? settings,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object> get props => [settings];
}
