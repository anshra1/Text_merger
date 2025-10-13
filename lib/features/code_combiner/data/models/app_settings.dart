// Last Edited: 2025-08-11 15:30:00
// Edit History: 
//      - 2025-08-11 15:30:00: Added defaults() factory constructor with 
//        sensible app defaults - Purpose: Move domain logic to model and 
//        provide consistent default values for new installations
//      - 2025-08-11 14:39:30: Applied 80-character line limit to edit 
//        comments - Purpose: Improve readability and maintain consistent 
//        formatting
//      - 2025-08-11 14:36:30: Converted to Freezed model with JSON 
//        serialization - Purpose: Eliminate boilerplate code and enable 
//        SharedPreferences storage

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required int fileSplitSizeInMB,
    required int maxTokenWarningLimit,
    required bool warnOnTokenExceed,
    required bool stripCommentsFromCode,
    String? defaultExportLocation,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// Factory constructor providing sensible default app settings for new installations
  factory AppSettings.defaults() {
    return const AppSettings(
      fileSplitSizeInMB: 5,
      maxTokenWarningLimit: 50000,
      warnOnTokenExceed: true,
      stripCommentsFromCode: false,
    );
  }


  /// Async factory constructor that sets Documents directory as default export location
  /// Use this when you need the platform-specific Documents directory path
  static Future<AppSettings> defaultsWithDocumentsPath() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final codeCombinerPath = '${documentsDirectory.path}/code-combiner';
      return AppSettings(
        fileSplitSizeInMB: 5,
        maxTokenWarningLimit: 80000,
        warnOnTokenExceed: true,
        stripCommentsFromCode: true,
        defaultExportLocation: codeCombinerPath,
      );
    } on Exception catch (_) {
      // Fallback to regular defaults if path_provider fails
      return AppSettings.defaults();
    }
  }
}