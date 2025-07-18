/// Base exception class for the application
abstract class AppException implements Exception {
  const AppException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message, [super.code]);
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException(super.message, [super.code]);
}

/// Firebase-related exceptions
class FirebaseException extends AppException {
  const FirebaseException(super.message, [super.code]);
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
}
