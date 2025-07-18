import 'dart:developer' as developer;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Service class to manage Firebase Crashlytics functionality
class CrashlyticsService {
  static CrashlyticsService? _instance;
  static CrashlyticsService get instance =>
      _instance ??= CrashlyticsService._();

  CrashlyticsService._();

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

  /// Log a message to Crashlytics
  Future<void> log(String message) async {
    try {
      await _crashlytics.log(message);
      if (kDebugMode) {
        developer.log(message, name: 'CrashlyticsService');
      }
    } catch (e) {
      developer.log('Failed to log message: $e', name: 'CrashlyticsService');
    }
  }

  /// Record a non-fatal error
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Iterable<Object> information = const [],
    bool printDetails = true,
    bool fatal = false,
  }) async {
    try {
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        information: information,
        printDetails: printDetails,
        fatal: fatal,
      );

      if (kDebugMode) {
        developer.log(
          'Error recorded: $exception',
          name: 'CrashlyticsService',
          error: exception,
          stackTrace: stackTrace,
        );
      }
    } catch (e) {
      developer.log('Failed to record error: $e', name: 'CrashlyticsService');
    }
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
