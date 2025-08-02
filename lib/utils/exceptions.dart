/// Enhanced base exception class for the application with better context
abstract class AppException implements Exception {
  const AppException(
    this.message, [
    this.code,
    this.context,
    this.stackTrace,
  ]);

  final String message;
  final String? code;
  final Map<String, dynamic>? context;
  final StackTrace? stackTrace;

  @override
  String toString() {
    final buffer = StringBuffer('AppException: $message');
    if (code != null) buffer.write(' (Code: $code)');
    if (context != null && context!.isNotEmpty) {
      buffer.write(' Context: $context');
    }
    return buffer.toString();
  }

  /// Convert to a user-friendly message
  String get userMessage => message;

  /// Check if this exception should be retried
  bool get isRetryable => false;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
  
  @override
  bool get isRetryable => true;
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
  
  @override
  bool get isRetryable => true;
}

/// Firebase-related exceptions
class FirebaseException extends AppException {
  const FirebaseException(super.message, [super.code]);
  
  @override
  bool get isRetryable => code != 'permission-denied';
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
  
  @override
  bool get isRetryable => code != '4xx'; // Only retry non-client errors
}
