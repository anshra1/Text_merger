// Last Edited: 2025-08-12 01:00:00
// Edit History:
//      - 2025-08-12 01:00:00: Updated clearRecentWorkspaces to return empty
//        list for UI consistency - Purpose: Complete API consistency where
//        all operations return updated state for immediate UI updates
//      - 2025-08-12 00:45:00: Updated removeRecentWorkspace to return sorted
//        list for UI consistency - Purpose: Maintain consistent API pattern
//        where all modification operations return updated data
//      - 2025-08-12 00:30:00: Added raw data helper and eliminated double
//        sorting - Purpose: Optimize performance by ensuring single sort
//        operation and centralized raw data loading

import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_merger/core/error/exception.dart';
import 'package:text_merger/features/code_combiner/data/models/app_settings.dart';
import 'package:text_merger/features/code_combiner/data/models/filter_settings.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';

abstract class LocalStorageDataSource {
  /// Purpose: Add workspace path to recent list (handles deduplication and ordering)
  Future<List<RecentWorkspace>> addRecentWorkspace(String workspacePath);

  /// Purpose: Remove workspace from recent list by path
  Future<List<RecentWorkspace>> removeRecentWorkspace(String workspacePath);

  /// Purpose: Toggle favorite flag for a recent workspace and return updated list
  Future<List<RecentWorkspace>> toggleFavoriteRecentWorkspace(String workspacePath);

  /// Purpose: Retrieve saved recent workspaces from local storage on app startup
  Future<List<RecentWorkspace>> loadRecentWorkspaces();

  /// Purpose: Clear all recent workspaces
  Future<List<RecentWorkspace>> clearRecentWorkspaces();

  /// Purpose: Save user's filter preferences (file extensions, folder exclusions) to storage
  Future<bool> saveFilterSettings(FilterSettings settings);

  /// Purpose: Load user's saved filter settings or return defaults if none exist
  Future<FilterSettings> loadFilterSettings();

  /// Purpose: Persist application-wide settings (theme, token limits, export preferences)
  Future<void> saveAppSettings(AppSettings settings);

  /// Purpose: Load application settings from storage or return defaults for first-time users
  Future<AppSettings> loadAppSettings();
}

class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  LocalStorageDataSourceImpl(this.prefs);

  // this will be injected by the constructor in getIt
  final SharedPreferences prefs;

  // Storage keys - using constants to prevent typos and enable refactoring
  static const String _keyRecentWorkspaces = 'recent_workspaces';
  static const String _keyFilterSettings = 'filter_settings';
  static const String _keyAppSettings = 'app_settings';

  /// Purpose: Add workspace path to recent list with deduplication and ordering
  @override
  Future<List<RecentWorkspace>> addRecentWorkspace(String workspacePath) async {
    if (!_validateWorkspacePath(workspacePath)) {
      throw const ValidationException(
        methodName: 'addRecentWorkspace',
        originalError: 'Workspace path validation failed',
        userMessage: 'Invalid workspace path provided',
        title: 'Data Validation Error',
        debugDetails: 'Workspace path is empty or invalid',
      );
    }

    try {
      // Load existing workspaces (raw, unsorted)
      final workspaces = await _loadRecentWorkspacesRaw();

      // Remove existing entry with same path (deduplication)
      workspaces.removeWhere((workspace) => workspace.path == workspacePath);

      // Add new workspace to the list
      final newWorkspace = RecentWorkspace(
        path: workspacePath,
        lastAccessed: DateTime.now(),
        isFavorite: false,
      );
      workspaces.add(newWorkspace);

      // Maintain size limit (max 15 recent workspaces)
      const maxRecentWorkspaces = 15;
      if (workspaces.length > maxRecentWorkspaces) {
        workspaces.removeRange(maxRecentWorkspaces, workspaces.length);
      }

      // Save the raw unsorted list
      await _saveWorkspacesList(workspaces);

      // Sort and return the updated list (single sort operation)
      return _sortWorkspaces(workspaces);
    } on Exception catch (e) {
      throw StorageException(
        methodName: 'addRecentWorkspace',
        originalError: e.toString(),
        userMessage: 'Failed to add recent workspace',
        title: 'Storage Write Error',
        debugDetails: 'Failed to update recent workspaces list',
      );
    }
  }

  /// Purpose: Remove workspace from recent list by path and return updated list
  @override
  Future<List<RecentWorkspace>> removeRecentWorkspace(String workspacePath) async {
    try {
      // Load raw data without sorting
      final workspaces = await _loadRecentWorkspacesRaw();

      // Remove workspace with matching path
      workspaces.removeWhere((workspace) => workspace.path == workspacePath);

      // Save updated raw list
      await _saveWorkspacesList(workspaces);

      // Return sorted list for immediate UI update
      return _sortWorkspaces(workspaces);
    } on Exception catch (e) {
      throw StorageException(
        methodName: 'removeRecentWorkspace',
        originalError: e.toString(),
        userMessage: 'Failed to remove recent workspace',
        title: 'Storage Write Error',
        debugDetails: 'Failed to update recent workspaces list',
      );
    }
  }

  /// Purpose: Toggle favorite flag for a recent workspace and return sorted list
  @override
  Future<List<RecentWorkspace>> toggleFavoriteRecentWorkspace(
    String workspacePath,
  ) async {
    try {
      // Load raw list (unsorted) to mutate in place
      final workspaces = await _loadRecentWorkspacesRaw();

      final index = workspaces.indexWhere((w) => w.path == workspacePath);
      if (index != -1) {
        final current = workspaces[index];
        // Flip favorite flag; preserve lastAccessed timestamp
        workspaces[index] = current.copyWith(isFavorite: !current.isFavorite);

        // Persist mutated list
        await _saveWorkspacesList(workspaces);
      }

      // Return sorted list for immediate UI update
      return _sortWorkspaces(workspaces);
    } on Exception catch (e) {
      throw StorageException(
        methodName: 'toggleFavoriteRecentWorkspace',
        originalError: e.toString(),
        userMessage: 'Failed to toggle favorite for workspace',
        title: 'Storage Write Error',
        debugDetails: 'Unable to update favorite flag in storage',
      );
    }
  }

  /// Purpose: Clear all recent workspaces from storage and return empty list
  @override
  Future<List<RecentWorkspace>> clearRecentWorkspaces() async {
    try {
      await prefs.remove(_keyRecentWorkspaces);
      // Return empty list for immediate UI update
      return <RecentWorkspace>[];
    } on Exception catch (e) {
      throw StorageException(
        methodName: 'clearRecentWorkspaces',
        originalError: e.toString(),
        userMessage: 'Failed to clear recent workspaces',
        title: 'Storage Write Error',
        debugDetails: 'Failed to remove recent workspaces from storage',
      );
    }
  }

  /// Purpose: Validate workspace path before adding to recent list
  bool _validateWorkspacePath(String workspacePath) {
    // Essential fields must not be empty to maintain data integrity
    if (workspacePath.isEmpty) {
      return false;
    }

    // Optional path existence validation (non-blocking)
    try {
      if (!Directory(workspacePath).existsSync() && !File(workspacePath).existsSync()) {
        // Path doesn't exist but we'll still allow it (might be on removable media)
        // This is optional validation - we don't fail on missing paths
      }
    } on Exception catch (_) {
      // Path validation failed, but continue - this is optional validation
      // We allow non-existent paths as they might be on removable media
      // FileSystemException, permissions, network drives, etc. are acceptable
    }
    return true;
  }

  /// Purpose: Sort workspaces with favorites first, then by date (newest first)
  List<RecentWorkspace> _sortWorkspaces(List<RecentWorkspace> workspaces) {
    workspaces.sort((a, b) {
      // If one is favorite and other is not, favorite comes first
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;

      // If both have same favorite status, sort by date (newest first)
      // This handles: both favorites OR both non-favorites
      return b.lastAccessed.compareTo(a.lastAccessed);
    });
    return workspaces;
  }

  /// Purpose: Private helper to save workspaces list to storage
  Future<void> _saveWorkspacesList(List<RecentWorkspace> workspaces) async {
    try {
      // Convert each workspace to JSON using model's built-in serialization
      final jsonList = workspaces.map((workspace) => workspace.toJson()).toList();
      // Encode the entire list as a JSON string for storage
      final jsonString = jsonEncode(jsonList);
      // Persist to SharedPreferences with await to handle async storage
      await prefs.setString(_keyRecentWorkspaces, jsonString);
    } on Exception catch (e) {
      throw StorageException(
        methodName: '_saveWorkspacesList',
        originalError: e.toString(),
        userMessage: 'Failed to save workspaces list',
        title: 'Storage Write Error',
        debugDetails: 'JSON encoding or SharedPreferences write failed',
      );
    }
  }

  /// Purpose: Load raw workspace data without sorting (internal helper)
  Future<List<RecentWorkspace>> _loadRecentWorkspacesRaw() async {
    try {
      // Retrieve JSON string from SharedPreferences
      final jsonString = prefs.getString(_keyRecentWorkspaces);
      // Handle empty/null case gracefully with defaults
      if (jsonString == null || jsonString.isEmpty) {
        return <RecentWorkspace>[];
      }

      // Parse JSON string into List<dynamic> with type safety
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      // Convert each JSON object back to RecentWorkspace using model's fromJson
      return jsonList
          .map((json) => RecentWorkspace.fromJson(json as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e) {
      throw StorageException(
        methodName: '_loadRecentWorkspacesRaw',
        originalError: e.toString(),
        userMessage: 'Failed to load recent workspaces - corrupted data',
        title: 'Storage Data Corruption',
        debugDetails: 'JSON decoding failed, data may be corrupted',
      );
    } on Exception catch (e) {
      throw StorageException(
        methodName: '_loadRecentWorkspacesRaw',
        originalError: e.toString(),
        userMessage: 'Failed to load recent workspaces',
        title: 'Storage Read Error',
        debugDetails: 'Unable to deserialize workspace data from storage',
      );
    }
  }

  /// Purpose: Load and deserialize recent workspaces from storage with sorting
  @override
  Future<List<RecentWorkspace>> loadRecentWorkspaces() async {
    // Load raw data and sort it
    final workspaces = await _loadRecentWorkspacesRaw();
    return _sortWorkspaces(workspaces);
  }

  /// Purpose: Save user's filter preferences to storage and return success status
  @override
  Future<bool> saveFilterSettings(FilterSettings settings) async {
    if (!_validateFilterSettings(settings)) {
      throw const ValidationException(
        methodName: 'saveFilterSettings',
        originalError: 'Filter settings validation failed',
        userMessage: 'Invalid filter settings provided',
        title: 'Settings Validation Error',
        debugDetails: 'Filter settings contain invalid extensions or size limits',
      );
    }

    try {
      // Use model's built-in JSON serialization for consistency
      final jsonString = jsonEncode(settings.toJson());
      // Persist to storage with await to handle async operation
      await prefs.setString(_keyFilterSettings, jsonString);
      // Return success indicator for caller to handle UI feedback
      return true;
    } on Exception catch (e) {
      throw StorageException(
        methodName: 'saveFilterSettings',
        originalError: e.toString(),
        userMessage: 'Failed to save filter settings',
        title: 'Storage Write Error',
        debugDetails:
            'JSON encoding or SharedPreferences write failed for filter settings',
      );
    }
  }

  /// Purpose: Validate filter settings data before saving to ensure data integrity
  bool _validateFilterSettings(FilterSettings settings) {
    // Ensure file extensions follow proper format conventions
    for (final ext in settings.blockedExtensions) {
      if (!ext.startsWith('.')) {
        return false; // Extensions must be like '.txt', '.exe', not 'txt' or '.'
      }
    }

    // Validate file size limits are within reasonable bounds
    if (settings.maxFileSizeInMB < 0 || settings.maxFileSizeInMB > 1000) {
      return false; // Negative sizes invalid, 1GB max is reasonable for text files
    }

    return true; // All validation checks passed
  }

  /// Purpose: Load saved filter settings or return defaults for new installations
  @override
  Future<FilterSettings> loadFilterSettings() async {
    try {
      // Retrieve filter settings JSON from storage
      final jsonString = prefs.getString(_keyFilterSettings);
      // Handle first-time use or cleared storage gracefully
      if (jsonString == null || jsonString.isEmpty) {
        return FilterSettings.defaults(); // Use factory method from domain model
      }

      // Parse JSON string with type safety
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      // Use model's fromJson for consistent deserialization
      return FilterSettings.fromJson(data);
    } on FormatException catch (e) {
      throw StorageException(
        methodName: 'loadFilterSettings',
        originalError: e.toString(),
        userMessage: 'Failed to load filter settings - corrupted data',
        title: 'Storage Data Corruption',
        debugDetails: 'JSON decoding failed, filter settings data may be corrupted',
      );
    } on Exception catch (e) {
      throw StorageException(
        methodName: 'loadFilterSettings',
        originalError: e.toString(),
        userMessage: 'Failed to load filter settings',
        title: 'Storage Read Error',
        debugDetails: 'Unable to deserialize filter settings data from storage',
      );
    }
  }

  /// Purpose: Persist application-wide settings to local storage
  @override
  Future<void> saveAppSettings(AppSettings settings) async {
    if (!_validateAppSettings(settings)) {
      throw const ValidationException(
        methodName: 'saveAppSettings',
        originalError: 'App settings validation failed',
        userMessage: 'Invalid application settings provided',
        title: 'Settings Validation Error',
        debugDetails: 'App settings contain invalid values or exceed limits',
      );
    }

    try {
      // Serialize app settings using model's built-in toJson method
      final jsonString = jsonEncode(settings.toJson());
      // Persist to SharedPreferences with async handling
      await prefs.setString(_keyAppSettings, jsonString);
    } on Exception catch (e) {
      throw StorageException(
        methodName: 'saveAppSettings',
        originalError: e.toString(),
        userMessage: 'Failed to save application settings',
        title: 'Storage Write Error',
        debugDetails: 'JSON encoding or SharedPreferences write failed',
      );
    }
  }

  /// Purpose: Validate app settings data integrity before storage operation
  bool _validateAppSettings(AppSettings settings) {
    // Ensure token warning limit is within practical bounds
    if (settings.maxTokenWarningLimit > 1000000) {
      return false; // 1M maximum for any practical model
    }

    // Optional validation for export location (if user specified one)
    if (settings.defaultExportLocation?.isNotEmpty ?? false) {
      try {
        if (!Directory(settings.defaultExportLocation!).existsSync()) {
          // Allow non-existent paths as they might be created later
          // User might specify a path they intend to create
        }
      } on Exception catch (e) {
        throw ValidationException(
          methodName: '_validateAppSettings',
          originalError: e.toString(),
          userMessage: 'Invalid export location path',
          title: 'Path Validation Error',
          debugDetails:
              'Export location path validation failed: ${settings.defaultExportLocation}',
        );
      }
    }

    // Validate file splitting size is practical for export operations
    if (settings.fileSplitSizeInMB < 1 || settings.fileSplitSizeInMB > 100) {
      return false; // 1MB minimum useful, 100MB maximum for reasonable file handling
    }

    return true; // All validation checks passed
  }

  /// Purpose: Load application settings from storage or initialize with defaults
  @override
  Future<AppSettings> loadAppSettings() async {
    try {
      // Retrieve app settings JSON from SharedPreferences
      final jsonString = prefs.getString(_keyAppSettings);
      // Handle first-time use or cleared storage with sensible defaults
      if (jsonString == null || jsonString.isEmpty) {
        return AppSettings.defaultsWithDocumentsPath(); // Use Documents directory as default
      }

      // Parse JSON with type safety to prevent runtime errors
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      // Deserialize using model's fromJson for consistency
      return AppSettings.fromJson(data);
    } on FormatException catch (e) {
      throw StorageException(
        methodName: 'loadAppSettings',
        originalError: e.toString(),
        userMessage: 'Failed to load app settings - corrupted data',
        title: 'Storage Data Corruption',
        debugDetails: 'JSON decoding failed, app settings data may be corrupted',
      );
    } on Exception catch (e) {
      throw StorageException(
        methodName: 'loadAppSettings',
        originalError: e.toString(),
        userMessage: 'Failed to load app settings',
        title: 'Storage Read Error',
        debugDetails: 'Unable to deserialize app settings data from storage',
      );
    }
  }
}
