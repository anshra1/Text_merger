import 'package:text_merger/core/error/exception.dart';
import 'package:text_merger/core/error/failure.dart';

class ErrorMapper {
  static Failure mapErrorToFailure(dynamic error) {
    // Since exceptions already have proper messages and codes,
    // we just need to map them directly

    if (error is ServerException) {
      return ServerFailure(
        message: error.userMessage,
        isRecoverable: error.isRecoverable,
        title: error.title,
        priority: error.priority,
      );
    }

    if (error is ServerException) {
      return ServerFailure(
        message: error.userMessage,
        isRecoverable: error.isRecoverable,
        title: error.title, // Added title
        priority: error.priority, // Added priority
      );
    }

    // Validation Exceptions
    if (error is ValidationException) {
      return ValidationFailure(
        message: error.userMessage, // Changed to error.userMessage
        isRecoverable: error.isRecoverable,
        title: error.title, // Added title
        priority: error.priority, // Added priority
      );
    }

    // Network Exceptions
    if (error is NetworkException) {
      return NetworkFailure(
        message: error.userMessage, // Changed to error.userMessage
        isRecoverable: error.isRecoverable,
        title: error.title, // Added title
        priority: error.priority, // Added priority
      );
    }

    // Cache Exceptions
    if (error is CacheException) {
      return CacheFailure(
        message: error.userMessage, // Changed to error.userMessage
        isRecoverable: error.isRecoverable,
        title: error.title, // Added title
        priority: error.priority, // Added priority
      );
    }

    if (error is StorageException) {
      return StorageFailure(
        message: error.userMessage, // Changed to error.userMessage
        isRecoverable: error.isRecoverable,
        title: error.title, // Added title
        priority: error.priority, // Added priority
      );
    }

    if (error is FileSystemException) {
      return FileSystemFailure(
        message: error.userMessage,
        isRecoverable: error.isRecoverable,
        title: error.title,
        priority: error.priority,
      );
    }

    // Unknown/Unexpected Errors
    return const UnknownFailure(
      message: 'Unknown Error',
    );
  }
}
