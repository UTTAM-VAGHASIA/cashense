import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:cashense/flavors/flavor_config.dart';

/// Custom logger for the application
class AppLogger {
  AppLogger._();

  static const String _name = 'Cashense';

  /// Log debug message
  static void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_shouldLog()) return;

    final logMessage = _formatMessage(message, tag);

    if (kDebugMode) {
      developer.log(
        logMessage,
        name: _name,
        level: 500, // Debug level
        error: error,
        stackTrace: stackTrace,
      );
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

    developer.log(
      logMessage,
      name: _name,
      level: 800, // Info level
      error: error,
      stackTrace: stackTrace,
    );
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

    developer.log(
      logMessage,
      name: _name,
      level: 900, // Warning level
      error: error,
      stackTrace: stackTrace,
    );
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

    developer.log(
      logMessage,
      name: _name,
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
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

    final buffer = StringBuffer();
    buffer.writeln('🌐 Network Request:');
    buffer.writeln('Method: $method');
    buffer.writeln('URL: $url');

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('Headers: $headers');
    }

    if (body != null && body.isNotEmpty) {
      buffer.writeln('Body: $body');
    }

    if (statusCode != null) {
      buffer.writeln('Status Code: $statusCode');
    }

    if (response != null) {
      buffer.writeln('Response: $response');
    }

    info(buffer.toString(), tag: 'Network');
  }

  /// Log navigation
  static void navigation(
    String from,
    String to, {
    Map<String, dynamic>? arguments,
  }) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('🧭 Navigation:');
    buffer.writeln('From: $from');
    buffer.writeln('To: $to');

    if (arguments != null && arguments.isNotEmpty) {
      buffer.writeln('Arguments: $arguments');
    }

    info(buffer.toString(), tag: 'Navigation');
  }

  /// Log user action
  static void userAction(String action, {Map<String, dynamic>? data}) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('👤 User Action:');
    buffer.writeln('Action: $action');

    if (data != null && data.isNotEmpty) {
      buffer.writeln('Data: $data');
    }

    info(buffer.toString(), tag: 'UserAction');
  }

  /// Log performance metrics
  static void performance(
    String operation,
    Duration duration, {
    Map<String, dynamic>? metrics,
  }) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('⚡ Performance:');
    buffer.writeln('Operation: $operation');
    buffer.writeln('Duration: ${duration.inMilliseconds}ms');

    if (metrics != null && metrics.isNotEmpty) {
      buffer.writeln('Metrics: $metrics');
    }

    info(buffer.toString(), tag: 'Performance');
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

    final buffer = StringBuffer();
    buffer.writeln('🗄️ Database:');
    buffer.writeln('Operation: $operation');
    buffer.writeln('Table: $table');

    if (query != null) {
      buffer.writeln('Query: $query');
    }

    if (data != null && data.isNotEmpty) {
      buffer.writeln('Data: $data');
    }

    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }

    info(buffer.toString(), tag: 'Database');
  }

  /// Log authentication events
  static void auth(String event, {String? userId, Map<String, dynamic>? data}) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('🔐 Authentication:');
    buffer.writeln('Event: $event');

    if (userId != null) {
      buffer.writeln('User ID: $userId');
    }

    if (data != null && data.isNotEmpty) {
      buffer.writeln('Data: $data');
    }

    info(buffer.toString(), tag: 'Auth');
  }

  /// Log Firebase events
  static void firebase(String event, {Map<String, dynamic>? data}) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('🔥 Firebase:');
    buffer.writeln('Event: $event');

    if (data != null && data.isNotEmpty) {
      buffer.writeln('Data: $data');
    }

    info(buffer.toString(), tag: 'Firebase');
  }

  /// Log GetX state changes
  static void state(
    String controller,
    String property,
    dynamic oldValue,
    dynamic newValue,
  ) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('🔄 State Change:');
    buffer.writeln('Controller: $controller');
    buffer.writeln('Property: $property');
    buffer.writeln('Old Value: $oldValue');
    buffer.writeln('New Value: $newValue');

    debug(buffer.toString(), tag: 'State');
  }

  /// Log lifecycle events
  static void lifecycle(
    String event,
    String screen, {
    Map<String, dynamic>? data,
  }) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('🔄 Lifecycle:');
    buffer.writeln('Event: $event');
    buffer.writeln('Screen: $screen');

    if (data != null && data.isNotEmpty) {
      buffer.writeln('Data: $data');
    }

    debug(buffer.toString(), tag: 'Lifecycle');
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

    final buffer = StringBuffer();
    buffer.writeln('➡️ Method Entry:');
    buffer.writeln('Class: $className');
    buffer.writeln('Method: $methodName');

    if (parameters != null && parameters.isNotEmpty) {
      buffer.writeln('Parameters: $parameters');
    }

    debug(buffer.toString(), tag: 'Method');
  }

  /// Log method exit
  static void methodExit(
    String className,
    String methodName, {
    dynamic result,
    Duration? duration,
  }) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('⬅️ Method Exit:');
    buffer.writeln('Class: $className');
    buffer.writeln('Method: $methodName');

    if (result != null) {
      buffer.writeln('Result: $result');
    }

    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }

    debug(buffer.toString(), tag: 'Method');
  }

  /// Log exception with context
  static void exception(
    Object exception,
    StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? additionalData,
  }) {
    if (!_shouldLog()) return;

    final buffer = StringBuffer();
    buffer.writeln('💥 Exception:');
    buffer.writeln('Type: ${exception.runtimeType}');
    buffer.writeln('Message: $exception');

    if (context != null) {
      buffer.writeln('Context: $context');
    }

    if (additionalData != null && additionalData.isNotEmpty) {
      buffer.writeln('Additional Data: $additionalData');
    }

    error(
      buffer.toString(),
      error: exception,
      stackTrace: stackTrace,
      tag: 'Exception',
    );
  }
}
