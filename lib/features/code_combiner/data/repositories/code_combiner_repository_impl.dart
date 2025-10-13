import 'package:dartz/dartz.dart';
import 'package:text_merger/core/error/error_mapper.dart' show ErrorMapper;
import 'package:text_merger/core/typedefs/type.dart';
import 'package:text_merger/features/code_combiner/data/datasources/file_system_data_source.dart';
import 'package:text_merger/features/code_combiner/data/datasources/local_storage_data_source.dart';
import 'package:text_merger/features/code_combiner/data/models/app_settings.dart';
import 'package:text_merger/features/code_combiner/data/models/export_preview.dart';
import 'package:text_merger/features/code_combiner/data/models/filter_settings.dart';
import 'package:text_merger/features/code_combiner/data/models/recent_workspace.dart';
import 'package:text_merger/features/code_combiner/domain/repositories/code_combiner_repository.dart';

class CodeCombinerRepositoryImpl implements CodeCombinerRepository {
  CodeCombinerRepositoryImpl({
    required this.fileSystemDataSource,
    required this.localStorageDataSource,
  });

  final FileSystemDataSource fileSystemDataSource;
  final LocalStorageDataSource localStorageDataSource;

  @override
  ResultFuture<WorkspaceData> openDirectoryTree(String directoryPath) async {
    try {
      // Coordinate multiple operations in single transaction
      final fileTree = await fileSystemDataSource.scanDirectory(directoryPath);
      final appSettings = await localStorageDataSource.loadAppSettings();
      final filterSettings = await localStorageDataSource.loadFilterSettings();
      await localStorageDataSource.addRecentWorkspace(directoryPath);

      final workspaceData = WorkspaceData(
        fileTree: fileTree,
        appSettings: appSettings,
        filterSettings: filterSettings,
        workspacePath: directoryPath,
      );

      return Right(workspaceData);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<List<RecentWorkspace>> getRecentWorkspaces() async {
    try {
      final result = await localStorageDataSource.loadRecentWorkspaces();
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<List<RecentWorkspace>> removeRecentWorkspace(String workspacePath) async {
    try {
      final result = await localStorageDataSource.removeRecentWorkspace(workspacePath);
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<List<RecentWorkspace>> toggleFavoriteRecentWorkspace(
    String workspacePath,
  ) async {
    try {
      final result = await localStorageDataSource.toggleFavoriteRecentWorkspace(
        workspacePath,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<List<RecentWorkspace>> clearRecentWorkspaces() async {
    try {
      final result = await localStorageDataSource.clearRecentWorkspaces();
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<String> readFileContent(String filePath) async {
    try {
      final result = await fileSystemDataSource.readFileContent(filePath);
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<ExportPreview> exportFiles(
    List<String> filePaths, {
    String? customSavePath,
  }) async {
    try {
      final result = await fileSystemDataSource.combineAndExportFiles(
        filePaths,
        customSavePath: customSavePath,
      );
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<FilterSettings> getFilterSettings() async {
    try {
      final result = await localStorageDataSource.loadFilterSettings();
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<bool> saveFilterSettings(FilterSettings settings) async {
    try {
      final result = await localStorageDataSource.saveFilterSettings(settings);
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<AppSettings> getAppSettings() async {
    try {
      final result = await localStorageDataSource.loadAppSettings();
      return Right(result);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }

  @override
  ResultFuture<void> saveAppSettings(AppSettings settings) async {
    try {
      await localStorageDataSource.saveAppSettings(settings);
      return const Right(null);
    } on Exception catch (e) {
      return Left(ErrorMapper.mapErrorToFailure(e));
    }
  }
}
