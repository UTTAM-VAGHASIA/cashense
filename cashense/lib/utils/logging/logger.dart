// ignore_for_file: avoid_print

// import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:cashense/flavors/flavor_config.dart';

/// Custom logger for the application
class AppLogger {
  AppLogger._();

  /// Log debug message
  static void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog()) return;

    final logMessage = _formatMessage(message, tag);
    print('🐛 DEBUG: $logMessage');

    if (error != null) {
      print('   Error: $error');
    }
    if (stackTrace != null) {
      print('   StackTrace: $stackTrace');
    }
  }

  /// Log info message
  static void info(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog()) return;

    final logMessage = _formatMessage(message, tag);
    print('ℹ️ INFO: $logMessage');

    if (error != null) {
      print('   Error: $error');
    }
    if (stackTrace != null) {
      print('   StackTrace: $stackTrace');
    }
  }

  /// Log warning message
  static void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog()) return;

    final logMessage = _formatMessage(message, tag);
    print('⚠️ WARNING: $logMessage');

    if (error != null) {
      print('   Error: $error');
    }
    if (stackTrace != null) {
      print('   StackTrace: $stackTrace');
    }
  }

  /// Log error message
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog()) return;

    final logMessage = _formatMessage(message, tag);
    print('❌ ERROR: $logMessage');

    if (error != null) {
      print('   Error: $error');
    }
    if (stackTrace != null) {
      print('   StackTrace: $stackTrace');
    }
  }

  /// Log network request
  static void network(
    String method,
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    int? statusCode,
    String? response,
  }) {
    if (!_shouldLog()) return;

    print('🌐 NETWORK: $method $url');
    if (headers != null && headers.isNotEmpty) {
      print('   Headers: $headers');
    }
    if (body != null && body.isNotEmpty) {
      print('   Body: $body');
    }
    if (statusCode != null) {
      print('   Status Code: $statusCode');
    }
    if (response != null) {
      print('   Response: $response');
    }
  }

  /// Log navigation
  static void navigation(
    String from,
    String to, {
    Map<String, dynamic>? arguments,
  }) {
    if (!_shouldLog()) return;

    print('🧭 NAVIGATION: $from → $to');
    if (arguments != null && arguments.isNotEmpty) {
      print('   Arguments: $arguments');
    }
  }

  /// Log user action
  static void userAction(String action, {Map<String, dynamic>? data}) {
    if (!_shouldLog()) return;

    print('👤 USER ACTION: $action');
    if (data != null && data.isNotEmpty) {
      print('   Data: $data');
    }
  }

  /// Log performance metrics
  static void performance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metrics,
  }) {
    if (!_shouldLog()) return;

    print('⚡ PERFORMANCE: $operation (${duration.inMilliseconds}ms)');
    if (metrics != null && metrics.isNotEmpty) {
      print('   Metrics: $metrics');
    }
  }

  /// Log database operation
  static void database(
    String operation,
    String table, {
    Map<String, dynamic>? data,
    String? query,
    Duration? duration,
  }) {
    if (!_shouldLog()) return;

    print('🗄️ DATABASE: $operation on $table');
    if (query != null) {
      print('   Query: $query');
    }
    if (data != null && data.isNotEmpty) {
      print('   Data: $data');
    }
    if (duration != null) {
      print('   Duration: ${duration.inMilliseconds}ms');
    }
  }

  /// Log authentication events
  static void auth(String event, {String? userId, Map<String, dynamic>? data}) {
    if (!_shouldLog()) return;

    print('🔐 AUTH: $event');
    if (userId != null) {
      print('   User ID: $userId');
    }
    if (data != null && data.isNotEmpty) {
      print('   Data: $data');
    }
  }

  /// Log Firebase events
  static void firebase(String event, {Map<String, dynamic>? data}) {
    if (!_shouldLog()) return;

    print('🔥 FIREBASE: $event');
    if (data != null && data.isNotEmpty) {
      print('   Data: $data');
    }
  }

  /// Log GetX state changes
  static void state(
    String controller,
    String property,
    dynamic oldValue,
    dynamic newValue,
  ) {
    if (!_shouldLog()) return;

    print('🔄 STATE: $controller.$property: $oldValue → $newValue');
  }

  /// Log lifecycle events
  static void lifecycle(
    String event,
    String screen, {
    Map<String, dynamic>? data,
  }) {
    if (!_shouldLog()) return;

    print('🔄 LIFECYCLE: $event on $screen');
    if (data != null && data.isNotEmpty) {
      print('   Data: $data');
    }
  }

  /// Format log message with timestamp and tag
  static String _formatMessage(String message, String? tag) {
    final timestamp = DateTime.now().toIso8601String();
    final tagPrefix = tag != null ? '[$tag] ' : '';
    return '$timestamp $tagPrefix$message';
  }

  /// Check if logging should be enabled based on flavor configuration
  static bool _shouldLog() {
    try {
      return FlavorConfig.instance.settings.enableLogging;
    } catch (e) {
      // If FlavorConfig is not initialized, default to debug mode
      return kDebugMode;
    }
  }

  /// Log method entry
  static void methodEntry(
    String className,
    String methodName, {
    Map<String, dynamic>? parameters,
  }) {
    if (!_shouldLog()) return;

    print('➡️ METHOD ENTRY: $className.$methodName');
    if (parameters != null && parameters.isNotEmpty) {
      print('   Parameters: $parameters');
    }
  }

  /// Log method exit
  static void methodExit(
    String className,
    String methodName, {
    dynamic result,
    Duration? duration,
  }) {
    if (!_shouldLog()) return;

    print('⬅️ METHOD EXIT: $className.$methodName');
    if (result != null) {
      print('   Result: $result');
    }
    if (duration != null) {
      print('   Duration: ${duration.inMilliseconds}ms');
    }
  }

  /// Log exception with context
  static void exception(
    Object exception,
    StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    if (!_shouldLog()) return;

    print('💥 EXCEPTION: ${exception.runtimeType}');
    print('   Message: $exception');
    if (context != null) {
      print('   Context: $context');
    }
    if (additionalData != null && additionalData.isNotEmpty) {
      print('   Additional Data: $additionalData');
    }
    print('   StackTrace: $stackTrace');
  }
}
