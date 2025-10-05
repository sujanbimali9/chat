import 'dart:developer';
import 'package:chat/core/exception/exception.dart';
import 'package:chat/core/failure/failure.dart';
import 'package:chat/utils/constant/app_constants.dart';
import 'package:fpdart/fpdart.dart';

/// Mixin that provides standardized exception handling across repositories and data sources
mixin ExceptionHandlerMixin {
  /// Handles exceptions and converts them to Either<Failure, T> pattern
  ///
  /// [operation] - The async operation to execute
  /// [context] - Context string for logging (usually class.method name)
  /// [customErrorHandler] - Optional custom error handler for specific exceptions
  Future<Either<Failure, T>> handleException<T>(
    Future<T> Function() operation, {
    String context = '',
    Failure Function(Exception)? customErrorHandler,
  }) async {
    try {
      final result = await operation();
      return right(result);
    } on Exception catch (e) {
      // 🔹 Custom error handler has highest priority
      if (customErrorHandler != null) {
        final customFailure = customErrorHandler(e);
        log('Custom Exception handled: $e', name: '$runtimeType.$context');
        return left(customFailure);
      }

      if (e is ServerException) {
        log('Server Exception: ${e.message}', name: '$runtimeType.$context');
        return left(_mapServerException(e));
      } else if (e is CacheException) {
        log('Cache Exception: ${e.message}', name: '$runtimeType.$context');
        return left(CacheFailure(e.message));
      } else if (e is BadRequestException) {
        log(
          'Bad Request Exception: ${e.message}',
          name: '$runtimeType.$context',
        );
        return left(BadRequestFailure(e.message));
      } else if (e is UnauthorizedException) {
        log(
          'Unauthorized Exception: ${e.message}',
          name: '$runtimeType.$context',
        );
        return left(UnauthorizedFailure(e.message));
      } else if (e is ForbiddenException) {
        log('Forbidden Exception: ${e.message}', name: '$runtimeType.$context');
        return left(ForbiddenFailure(e.message));
      } else if (e is NotFoundException) {
        log('Not Found Exception: ${e.message}', name: '$runtimeType.$context');
        return left(NotFoundFailure(e.message));
      } else if (e is TimeoutException) {
        log('Timeout Exception: ${e.message}', name: '$runtimeType.$context');
        return left(TimeoutFailure(e.message));
      } else if (e is NoInternetException) {
        log(
          'No Internet Exception: ${e.message}',
          name: '$runtimeType.$context',
        );
        return left(NoInternetFailure(e.message));
      } else if (e is AuthException) {
        log('Auth Exception: ${e.message}', name: '$runtimeType.$context');
        return left(AuthFailure(e.message));
      }

      log('Unexpected Exception: $e', name: '$runtimeType.$context');
      return left(Failure(e.toString()));
    } catch (e) {
      log('Unknown Error: $e', name: '$runtimeType.$context');
      return left(Failure(ErrorMessages.unknownError));
    }
  }

  /// Handles exceptions without Either pattern (for void operations)
  ///
  /// [operation] - The async operation to execute
  /// [context] - Context string for logging
  /// [customErrorHandler] - Optional custom error handler
  Future<void> handleVoidException(
    Future<void> Function() operation, {
    String context = '',
    void Function(Exception)? customErrorHandler,
  }) async {
    try {
      await operation();
    } on ServerException catch (e) {
      log('Server Exception: ${e.message}', name: '$runtimeType.$context');
      rethrow;
    } on CacheException catch (e) {
      log('Cache Exception: ${e.message}', name: '$runtimeType.$context');
      rethrow;
    } on Exception catch (e) {
      if (customErrorHandler != null) {
        log('Custom Exception: $e', name: '$runtimeType.$context');
        customErrorHandler(e);
        return;
      }
      log('Unexpected Exception: $e', name: '$runtimeType.$context');
      rethrow;
    } catch (e) {
      log('Unknown Error: $e', name: '$runtimeType.$context');
      throw Exception(ErrorMessages.unknownError);
    }
  }

  /// Handles synchronous exceptions
  ///
  /// [operation] - The synchronous operation to execute
  /// [context] - Context string for logging
  /// [defaultValue] - Default value to return on error
  T handleSyncException<T>(
    T Function() operation, {
    String context = '',
    required T defaultValue,
  }) {
    try {
      return operation();
    } on Exception catch (e) {
      log('Sync Exception: $e', name: '$runtimeType.$context');
      return defaultValue;
    } catch (e) {
      log('Unknown Sync Error: $e', name: '$runtimeType.$context');
      return defaultValue;
    }
  }

  /// Maps server exceptions to appropriate failure types
  Failure _mapServerException(ServerException e) {
    final message = e.message.toLowerCase();

    if (message.contains('network') || message.contains('connection')) {
      return NoInternetFailure(e.message);
    } else if (message.contains('timeout')) {
      return TimeoutFailure(e.message);
    } else if (message.contains('unauthorized') || message.contains('401')) {
      return UnauthorizedFailure(e.message);
    } else if (message.contains('forbidden') || message.contains('403')) {
      return ForbiddenFailure(e.message);
    } else if (message.contains('not found') || message.contains('404')) {
      return NotFoundFailure(e.message);
    } else if (message.contains('bad request') || message.contains('400')) {
      return BadRequestFailure(e.message);
    }

    return ServerFailure(e.message);
  }
}

/// Mixin for local database exception handling
mixin LocalExceptionHandlerMixin {
  /// Handles local database exceptions
  Future<T> handleLocalException<T>(
    Future<T> Function() operation, {
    String context = '',
    T? defaultValue,
  }) async {
    try {
      return await operation();
    } on Exception catch (e) {
      log('Local Database Exception: $e', name: '$runtimeType.$context');
      if (defaultValue != null) {
        return defaultValue;
      }
      throw const CacheException(ErrorMessages.databaseError);
    } catch (e) {
      log('Unknown Local Error: $e', name: '$runtimeType.$context');
      if (defaultValue != null) {
        return defaultValue;
      }
      throw const CacheException(ErrorMessages.unknownError);
    }
  }
}

/// Mixin for network operation exception handling
mixin NetworkExceptionHandlerMixin {
  /// Handles network-specific exceptions with retry logic
  Future<T> handleNetworkException<T>(
    Future<T> Function() operation, {
    String context = '',
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;

    while (attempts < maxRetries) {
      try {
        return await operation();
      } on Exception catch (e) {
        attempts++;
        log(
          'Network Exception (attempt $attempts): $e',
          name: '$runtimeType.$context',
        );

        if (attempts >= maxRetries) {
          if (e is ServerException || e is TimeoutException) {
            throw const NoInternetException(ErrorMessages.networkError);
          }
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(retryDelay * attempts);
      }
    }

    throw const NoInternetException(ErrorMessages.networkError);
  }
}
