import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:text_merger/core/error/error_priority_enum.dart';

/// Base exception class for application-wide error handling.
///
/// Provides standardized error reporting with context details, priority levels,
/// and formatting for both UI presentation and logging.
@immutable
abstract class AppException extends Equatable implements Exception {
  const AppException({
    required this.userMessage,
    required this.methodName,
    required this.originalError,
    required this.title, // Added title as a required parameter, this.stackTrace,
    this.debugDetails,
    this.stackTrace,
    this.priority = ErrorPriority.low,
    this.isRecoverable = false,
  });

  /// The original error that caused this exception
  final String originalError;

  /// Stack trace where the error occurred
  final String? stackTrace;

  /// User-friendly message that can be shown in the UI
  final String userMessage;

  /// Method name where the exception was thrown
  final String methodName;

  /// Additional contextual information for debugging
  final String? debugDetails;

  /// Error priority level
  final ErrorPriority priority;

  /// Indicates if the application can recover from this error
  final bool isRecoverable;

  /// Title of the exception
  final String title; // New title variable

  @override
  List<Object?> get props => [
    userMessage,
    debugDetails,
    stackTrace,
    priority,
    isRecoverable,
    methodName,
    originalError,
    title, // Include title in props
  ];

  @override
  String toString() {
    final timestamp = DateTime.now().toIso8601String();
    final formattedStack = stackTrace ?? 'No stack trace available';

    return '''
----------------------------------------
Time: $timestamp
Method: $methodName
Original Error: $originalError
Stack Trace:
$formattedStack
User Message: $userMessage
Title: $title // Include title in the string representation

Debug Details: ${debugDetails ?? 'None'}
Priority: ${priority.name}
Is Recoverable: $isRecoverable

----------------------------------------
''';
  }
}

/// Exception representing server-side errors
class ServerException extends AppException {
  const ServerException({
    required super.methodName,
    required super.originalError,
    required super.userMessage,
    required super.title, // Added title to constructor
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.high,
    super.isRecoverable = true,
  });
}

/// Exception for issues related to local cache operations
class CacheException extends AppException {
  const CacheException({
    required super.methodName,
    required super.originalError,
    required super.userMessage,
    required super.title, // Added title to constructor
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.medium,
    super.isRecoverable = true,
  });
}

/// Exception for general storage issues
class StorageException extends AppException {
  const StorageException({
    required super.originalError,
    required super.methodName,
    required super.userMessage,
    required super.title, // Added title to constructor
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.medium,
    super.isRecoverable = true,
  });
}

/// Exception for ObjectBox database operations
class ObjectBoxException extends AppException {
  const ObjectBoxException({
    required super.originalError,
    required super.methodName,
    required super.userMessage,
    required super.title, // Added title to constructor
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.high,
    super.isRecoverable,
  });
}

/// Exception for network connectivity issues
class NetworkException extends AppException {
  const NetworkException({
    required super.methodName,
    required super.originalError,
    required super.userMessage,
    required super.title, // Added title to constructor
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.high,
    super.isRecoverable = true,
  });
}

/// Exception specifically for network timeout issues
class NetworkTimeoutException extends NetworkException {
  const NetworkTimeoutException({
    required super.methodName,
    required super.originalError,
    required super.userMessage,
    required super.title, // Added title to constructor
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.medium,
    super.isRecoverable,
  });
}

/// Exception for data validation errors
class ValidationException extends AppException {
  const ValidationException({
    required super.methodName,
    required super.originalError,
    required super.userMessage,
    required super.title, // Added title to constructor
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.medium,
    super.isRecoverable = true,
  });
}

/// Exception for permission-related issues
class PermissionDeniedException extends AppException {
  const PermissionDeniedException({
    required super.methodName,
    required super.originalError,
    required super.userMessage,
    required super.title, // Added title to constructor
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.high,
    super.isRecoverable,
  });
}

/// Exception for application initialization errors
class InitializationException extends AppException {
  const InitializationException({
    required super.methodName,
    required super.originalError,
    required super.title,
    required super.userMessage, // Added title to constructor, super.userMessage = 'Application initialization failed',
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.critical,
    super.isRecoverable,
  });
}

/// Exception for file system operations
class FileSystemException extends AppException {
  const FileSystemException({
    required super.methodName,
    required super.originalError,
    required super.userMessage,
    required super.title,
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.high,
    super.isRecoverable = true,
  });
}

/// Generic exception for unclassified errors
class UnknownException extends AppException {
  const UnknownException({
    required super.methodName,
    required super.originalError,
    required super.title,
    super.userMessage =
        'Unknown error occurred', // Added title to constructor, super.userMessage = 'An unexpected error occurred',
    super.debugDetails,
    super.stackTrace,
    super.priority = ErrorPriority.medium,
    super.isRecoverable,
  });
}
