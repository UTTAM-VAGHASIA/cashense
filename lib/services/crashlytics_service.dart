import 'dart:developer' as developer;
import 'dart:io' show Platform;
import 'package:cashense/utils/result.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Enhanced service class to manage Firebase Crashlytics functionality
/// 
/// **Improvements:**
/// - Better singleton pattern with lazy initialization
/// - Enhanced error context and categorization
/// - Performance optimizations for frequent operations
/// - Memory-efficient logging with rate limiting
class CrashlyticsService {
  static CrashlyticsService? _instance;
  static CrashlyticsService get instance =>
      _instance ??= CrashlyticsService._();

  CrashlyticsService._();

  // Rate limiting for frequent operations
  static const _maxLogsPerMinute = 100;
  static const _maxErrorsPerMinute = 50;
  final Map<String, List<DateTime>> _rateLimiters = {
    'logs': <DateTime>[],
    'errors': <DateTime>[],
  };

  /// Get Firebase Crashlytics instance
  FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;

  /// Initialize Crashlytics with user consent
  Future<void> initialize({bool enableInDebug = false}) async {
    try {
      // Enable/disable Crashlytics collection based on debug mode and user preference
      await _crashlytics.setCrashlyticsCollectionEnabled(
        !kDebugMode || enableInDebug,
      );

      if (kDebugMode && enableInDebug) {
        developer.log(
          'Crashlytics enabled in debug mode',
          name: 'CrashlyticsService',
        );
      }
    } catch (e) {
      developer.log(
        'Failed to initialize Crashlytics: $e',
        name: 'CrashlyticsService',
      );
    }
  }

  /// Set user identifier for crash reports
  Future<void> setUserId(String userId) async {
    try {
      await _crashlytics.setUserIdentifier(userId);
      developer.log(
        'User ID set for Crashlytics: $userId',
        name: 'CrashlyticsService',
      );
    } catch (e) {
      developer.log('Failed to set user ID: $e', name: 'CrashlyticsService');
    }
  }

  /// Set custom key-value pairs for crash reports
  Future<void> setCustomKey(String key, Object value) async {
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (e) {
      developer.log('Failed to set custom key: $e', name: 'CrashlyticsService');
    }
  }

  /// Set multiple custom keys at once
  Future<void> setCustomKeys(Map<String, Object> keys) async {
    for (final entry in keys.entries) {
      await setCustomKey(entry.key, entry.value);
    }
  }

  /// Log a message to Crashlytics with rate limiting
  Future<void> log(String message) async {
    if (!_shouldAllowOperation('logs', _maxLogsPerMinute)) {
      if (kDebugMode) {
        developer.log('Log rate limit exceeded, skipping: $message', 
                     name: 'CrashlyticsService');
      }
      return;
    }

    try {
      // Add timestamp for better debugging
      final timestampedMessage = '[${DateTime.now().toIso8601String()}] $message';
      await _crashlytics.log(timestampedMessage);
      
      if (kDebugMode) {
        developer.log(message, name: 'CrashlyticsService');
      }
    } catch (e) {
      developer.log('Failed to log message: $e', name: 'CrashlyticsService');
    }
  }

  /// Check if operation should be allowed based on rate limiting
  bool _shouldAllowOperation(String operation, int maxPerMinute) {
    final now = DateTime.now();
    final logs = _rateLimiters[operation]!;
    
    // Remove logs older than 1 minute
    logs.removeWhere((time) => now.difference(time).inMinutes >= 1);
    
    // Check if under limit
    if (logs.length >= maxPerMinute) {
      return false;
    }
    
    // Add current operation
    logs.add(now);
    return true;
  }

  /// Record a non-fatal error with enhanced context and rate limiting
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Iterable<Object> information = const [],
    bool printDetails = true,
    bool fatal = false,
    Map<String, Object>? context,
  }) async {
    if (!fatal && !_shouldAllowOperation('errors', _maxErrorsPerMinute)) {
      if (kDebugMode) {
        developer.log('Error rate limit exceeded, skipping: $exception', 
                     name: 'CrashlyticsService');
      }
      return;
    }

    try {
      // Enhanced context with device and app information
      final enhancedContext = <String, Object>{
        'error_timestamp': DateTime.now().toIso8601String(),
        'error_fatal': fatal,
        'error_type': exception.runtimeType.toString(),
        'dart_version': Platform.version,
        'platform': Platform.operatingSystem,
        ...?context,
      };

      // Set context information efficiently
      await setCustomKeys(enhancedContext);

      // Record the error with enhanced information
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        information: [
          ...information,
          'Platform: ${Platform.operatingSystem}',
          'Dart Version: ${Platform.version}',
        ],
        printDetails: printDetails,
        fatal: fatal,
      );

      if (kDebugMode) {
        developer.log(
          'Error recorded: $exception${reason != null ? ' - Reason: $reason' : ''}',
          name: 'CrashlyticsService',
          error: exception,
          stackTrace: stackTrace,
        );
      }
    } catch (e) {
      developer.log('Failed to record error: $e', name: 'CrashlyticsService');
    }
  }

  /// Record an error from Result pattern
  Future<void> recordFailure(
    AppFailure failure, {
    String? additionalContext,
    bool fatal = false,
  }) async {
    final context = <String, Object>{
      'failure_type': failure.runtimeType.toString(),
      'failure_code': failure.code ?? 'unknown',
    };

    if (additionalContext != null) {
      context['additional_context'] = additionalContext;
    }

    await recordError(
      failure.exception ?? Exception(failure.message),
      failure.stackTrace,
      reason: failure.message,
      fatal: fatal,
      context: context,
    );
  }

  /// Record a Flutter error
  Future<void> recordFlutterError(FlutterErrorDetails errorDetails) async {
    try {
      await _crashlytics.recordFlutterFatalError(errorDetails);

      if (kDebugMode) {
        developer.log(
          'Flutter error recorded: ${errorDetails.exception}',
          name: 'CrashlyticsService',
          error: errorDetails.exception,
          stackTrace: errorDetails.stack,
        );
      }
    } catch (e) {
      developer.log(
        'Failed to record Flutter error: $e',
        name: 'CrashlyticsService',
      );
    }
  }

  /// Test crash reporting (use only for testing)
  Future<void> testCrash() async {
    if (kDebugMode) {
      developer.log('Test crash triggered', name: 'CrashlyticsService');
      throw Exception('Test crash from Crashlytics service');
    }
  }

  /// Check if Crashlytics is enabled
  bool get isEnabled => !kDebugMode;

  /// Get crash report status
  Future<bool> isCrashlyticsCollectionEnabled() async {
    try {
      return _crashlytics.isCrashlyticsCollectionEnabled;
    } catch (e) {
      developer.log(
        'Failed to check Crashlytics status: $e',
        name: 'CrashlyticsService',
      );
      return false;
    }
  }

  /// Enable or disable Crashlytics collection
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    try {
      await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
      developer.log(
        'Crashlytics collection ${enabled ? 'enabled' : 'disabled'}',
        name: 'CrashlyticsService',
      );
    } catch (e) {
      developer.log(
        'Failed to set Crashlytics collection: $e',
        name: 'CrashlyticsService',
      );
    }
  }

  /// Record breadcrumb for debugging
  Future<void> recordBreadcrumb(
    String message, {
    Map<String, String>? data,
  }) async {
    final breadcrumb = StringBuffer(message);
    if (data != null && data.isNotEmpty) {
      breadcrumb.write(' - Data: ${data.toString()}');
    }
    await log(breadcrumb.toString());
  }

  /// Record user action for debugging
  Future<void> recordUserAction(
    String action, {
    Map<String, Object>? parameters,
  }) async {
    await log('User Action: $action');
    if (parameters != null) {
      await setCustomKeys(
        parameters.map((key, value) => MapEntry('action_$key', value)),
      );
    }
  }
}
