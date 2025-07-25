
import 'package:equatable/equatable.dart';

/// A Result type that represents either a success or failure
/// This provides better error handling than throwing exceptions
sealed class Result<T> extends Equatable {
  const Result();

  /// Create a successful result
  const factory Result.success(T data) = Success<T>;

  /// Create a failed result
  const factory Result.failure(AppFailure failure) = Failure<T>;

  /// Check if the result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the data if successful, null otherwise
  T? get data => switch (this) {
    Success<T>(data: final data) => data,
    Failure<T>() => null,
  };

  /// Get the failure if failed, null otherwise
  AppFailure? get failure => switch (this) {
    Success<T>() => null,
    Failure<T>(failure: final failure) => failure,
  };

  /// Transform the success value
  Result<U> map<U>(U Function(T) transform) {
    return switch (this) {
      Success<T>(data: final data) => Result.success(transform(data)),
      Failure<T>(failure: final failure) => Result.failure(failure),
    };
  }

  /// Transform the success value asynchronously
  Future<Result<U>> mapAsync<U>(Future<U> Function(T) transform) async {
    return switch (this) {
      Success<T>(data: final data) => Result.success(await transform(data)),
      Failure<T>(failure: final failure) => Result.failure(failure),
    };
  }

  /// Chain operations that return Results
  Result<U> flatMap<U>(Result<U> Function(T) transform) {
    return switch (this) {
      Success<T>(data: final data) => transform(data),
      Failure<T>(failure: final failure) => Result.failure(failure),
    };
  }

  /// Chain async operations that return Results
  Future<Result<U>> flatMapAsync<U>(
    Future<Result<U>> Function(T) transform,
  ) async {
    return switch (this) {
      Success<T>(data: final data) => await transform(data),
      Failure<T>(failure: final failure) => Result.failure(failure),
    };
  }

  /// Handle both success and failure cases
  U fold<U>(U Function(T) onSuccess, U Function(AppFailure) onFailure) {
    return switch (this) {
      Success<T>(data: final data) => onSuccess(data),
      Failure<T>(failure: final failure) => onFailure(failure),
    };
  }

  /// Handle both success and failure cases asynchronously
  Future<U> foldAsync<U>(
    Future<U> Function(T) onSuccess,
    Future<U> Function(AppFailure) onFailure,
  ) async {
    return switch (this) {
      Success<T>(data: final data) => await onSuccess(data),
      Failure<T>(failure: final failure) => await onFailure(failure),
    };
  }

  /// Get the data or throw the failure
  T getOrThrow() {
    return switch (this) {
      Success<T>(data: final data) => data,
      Failure<T>(failure: final failure) => throw failure,
    };
  }

  /// Get the data or return a default value
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success<T>(data: final data) => data,
      Failure<T>() => defaultValue,
    };
  }

  /// Get the data or compute a default value
  T getOrElseCompute(T Function() defaultValue) {
    return switch (this) {
      Success<T>(data: final data) => data,
      Failure<T>() => defaultValue(),
    };
  }
}

/// Success case of Result
final class Success<T> extends Result<T> {
  const Success(this.data);

  @override
  final T data;

  @override
  List<Object?> get props => [data];

  @override
  String toString() => 'Success($data)';
}

/// Failure case of Result
final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  @override
  final AppFailure failure;

  @override
  List<Object?> get props => [failure];

  @override
  String toString() => 'Failure($failure)';
}

/// Base class for application failures
abstract class AppFailure extends Equatable {
  const AppFailure({
    required this.message,
    this.code,
    this.exception,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final Exception? exception;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [message, code, exception];

  @override
  String toString() =>
      'AppFailure: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related failures
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Authentication-related failures
class AuthFailure extends AppFailure {
  const AuthFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Validation-related failures
class ValidationFailure extends AppFailure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Storage-related failures
class StorageFailure extends AppFailure {
  const StorageFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Server-related failures
class ServerFailure extends AppFailure {
  const ServerFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Cache-related failures
class CacheFailure extends AppFailure {
  const CacheFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Unknown/unexpected failures
class UnknownFailure extends AppFailure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.exception,
    super.stackTrace,
  });
}

/// Extension methods for easier Result handling
extension ResultExtensions<T> on Future<Result<T>> {
  /// Handle the result when the future completes
  Future<U> handle<U>(
    U Function(T) onSuccess,
    U Function(AppFailure) onFailure,
  ) async {
    final result = await this;
    return result.fold(onSuccess, onFailure);
  }

  /// Map the success value asynchronously
  Future<Result<U>> mapAsync<U>(Future<U> Function(T) transform) async {
    final result = await this;
    return result.mapAsync(transform);
  }

  /// Chain async operations
  Future<Result<U>> flatMapAsync<U>(
    Future<Result<U>> Function(T) transform,
  ) async {
    final result = await this;
    return result.flatMapAsync(transform);
  }
}

/// Utility functions for creating Results
class ResultUtils {
  ResultUtils._();

  /// Safely execute a function and return a Result
  static Result<T> tryCatch<T>(
    T Function() operation, {
    AppFailure Function(Exception)? onError,
  }) {
    try {
      return Result.success(operation());
    } on Exception catch (e, stackTrace) {
      final failure =
          onError?.call(e) ??
          UnknownFailure(
            message: e.toString(),
            exception: e,
            stackTrace: stackTrace,
          );
      return Result.failure(failure);
    }
  }

  /// Safely execute an async function and return a Result
  static Future<Result<T>> tryCatchAsync<T>(
    Future<T> Function() operation, {
    AppFailure Function(Exception)? onError,
  }) async {
    try {
      final result = await operation();
      return Result.success(result);
    } on Exception catch (e, stackTrace) {
      final failure =
          onError?.call(e) ??
          UnknownFailure(
            message: e.toString(),
            exception: e,
            stackTrace: stackTrace,
          );
      return Result.failure(failure);
    }
  }

  /// Convert a nullable value to a Result
  static Result<T> fromNullable<T>(T? value, {required AppFailure failure}) {
    return value != null ? Result.success(value) : Result.failure(failure);
  }

  /// Combine multiple Results into one
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final successes = <T>[];

    for (final result in results) {
      switch (result) {
        case Success<T>(data: final data):
          successes.add(data);
        case Failure<T>(failure: final failure):
          return Result.failure(failure);
      }
    }

    return Result.success(successes);
  }
}
