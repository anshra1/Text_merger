// Last Edited: 2025-08-11 15:30:00
// Edit History:
//      - 2025-08-11 15:30:00: Added defaults() factory constructor with
//        comprehensive filter settings - Purpose: Move domain logic to model
//        and provide sensible defaults for new installations
//      - 2025-08-11 14:39:15: Applied 80-character line limit to edit
//        comments - Purpose: Improve readability and maintain consistent
//        formatting
//      - 2025-08-11 14:36:15: Converted to Freezed model with JSON
//        serialization - Purpose: Eliminate boilerplate code and enable
//        persistent storage

import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_settings.freezed.dart';
part 'filter_settings.g.dart';

@freezed
class FilterSettings with _$FilterSettings {
  const factory FilterSettings({
    required Set<String> blockedExtensions,
    required Set<String> blockedFilePaths,
    required Set<String> blockedFileNames,
    required Set<String> blockedFolderNames,
    required int maxFileSizeInMB,
    required bool includeHiddenFiles,
    required Set<String> allowedExtensions,
    String? searchQuery,
  }) = _FilterSettings;

  factory FilterSettings.fromJson(Map<String, dynamic> json) =>
      _$FilterSettingsFromJson(json);

  /// Factory constructor providing sensible default filter settings for new installations
  factory FilterSettings.defaults() {
    return const FilterSettings(
      blockedExtensions: {},
      blockedFilePaths: {},
      blockedFileNames: {},
      blockedFolderNames: {},
      maxFileSizeInMB: 10,
      includeHiddenFiles: false,
      allowedExtensions: {},
    );
  }
}

/*











*/
