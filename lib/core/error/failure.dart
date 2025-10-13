// Package imports:

import 'package:equatable/equatable.dart';
import 'package:text_merger/core/error/error_priority_enum.dart';

class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.title, // Title is now required
    this.priority = ErrorPriority.low,
    this.isRecoverable = false,
  });

  final String message;
  final String title; // Title instance variable is now non-nullable
  final ErrorPriority priority;
  final bool isRecoverable;

  @override
  List<Object?> get props => [message, title]; // Updated to include title
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    required super.title,
    super.priority = ErrorPriority.high,
    super.isRecoverable = true,
  });
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    required super.title,
    super.priority = ErrorPriority.medium,
    super.isRecoverable = true,
  });
}

/// Failure for network-related errors
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    required super.title,
    super.priority = ErrorPriority.high,
    super.isRecoverable = true,
  });
}

/// Failure for cache-related errors
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    required super.title,
    super.priority = ErrorPriority.medium,
    super.isRecoverable = true,
  });
}

/// Failure for storage-related errors
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    required super.title,
    super.priority = ErrorPriority.medium,
    super.isRecoverable = true,
  });
}

/// Failure for file system-related errors
class FileSystemFailure extends Failure {
  const FileSystemFailure({
    required super.message,
    required super.title,
    super.priority = ErrorPriority.medium,
    super.isRecoverable = true,
  });
}

/// Failure for unknown/unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Unknown error occurred',
    super.title = 'Unknown Error',
    super.priority = ErrorPriority.medium,
    super.isRecoverable = false,
  });
}
