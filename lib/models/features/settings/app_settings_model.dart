import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'app_settings_model.freezed.dart';
part 'app_settings_model.g.dart';

/// Application settings model using Freezed for better immutability and code generation
@freezed
class AppSettingsModel with _$AppSettingsModel {
  const factory AppSettingsModel({
    @Default(true) bool crashlyticsEnabled,
    @Default(true) bool analyticsEnabled,
    @Default(false) bool debugMode,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default('en') String locale,
    @Default(true) bool notificationsEnabled,
    @Default(true) bool biometricAuthEnabled,
    @Default(30) int sessionTimeoutMinutes,
  }) = _AppSettingsModel;

  const AppSettingsModel._();

  /// Create from JSON with automatic deserialization
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  /// Validate session timeout range
  bool get isValidSessionTimeout {
    return sessionTimeoutMinutes >= 5 && sessionTimeoutMinutes <= 120;
  }

  /// Validate locale format
  bool get isValidLocale {
    if (locale.isEmpty || locale.length < 2) return false;
    final localeRegex = RegExp(r'^[a-z]{2}(-[A-Z]{2})?$');
    return localeRegex.hasMatch(locale);
  }

  /// Validate all settings
  bool get isValid {
    return isValidSessionTimeout && isValidLocale;
  }

  /// Get detailed validation errors
  List<String> get validationErrors {
    final errors = <String>[];

    if (!isValidSessionTimeout) {
      errors.add('Session timeout must be between 5 and 120 minutes');
    }

    if (!isValidLocale) {
      errors.add('Locale must be a valid language code (e.g., "en", "en-US")');
    }

    return errors;
  }

  /// Convert theme mode to Flutter ThemeMode
  ThemeMode get flutterThemeMode {
    return switch (themeMode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }

  /// Check if settings are privacy-focused
  bool get isPrivacyOptimized {
    return !crashlyticsEnabled &&
        !analyticsEnabled &&
        !notificationsEnabled &&
        sessionTimeoutMinutes <= 15;
  }

  /// Check if settings are development-friendly
  bool get isDevelopmentMode {
    return debugMode && sessionTimeoutMinutes >= 60;
  }

  /// Create default settings
  factory AppSettingsModel.defaultSettings() {
    return const AppSettingsModel();
  }
}

/// Type-safe enum for theme mode
@JsonEnum()
enum AppThemeMode {
  @JsonValue('light')
  light,
  @JsonValue('dark')
  dark,
  @JsonValue('system')
  system;

  /// Get display name for UI
  String get displayName {
    return switch (this) {
      AppThemeMode.light => 'Light',
      AppThemeMode.dark => 'Dark',
      AppThemeMode.system => 'System',
    };
  }

  /// Get icon for UI representation
  IconData get icon {
    return switch (this) {
      AppThemeMode.light => Icons.light_mode,
      AppThemeMode.dark => Icons.dark_mode,
      AppThemeMode.system => Icons.brightness_auto,
    };
  }
}
