/// Application settings model for MVVM architecture
class AppSettingsModel {
  final bool crashlyticsEnabled;
  final bool analyticsEnabled;
  final bool debugMode;
  final String themeMode; // 'light', 'dark', 'system'
  final String locale;
  final bool notificationsEnabled;
  final bool biometricAuthEnabled;
  final int sessionTimeoutMinutes;

  const AppSettingsModel({
    this.crashlyticsEnabled = true,
    this.analyticsEnabled = true,
    this.debugMode = false,
    this.themeMode = 'system',
    this.locale = 'en',
    this.notificationsEnabled = true,
    this.biometricAuthEnabled = true,
    this.sessionTimeoutMinutes = 30,
  });

  /// Create a copy of this AppSettingsModel with some fields replaced
  AppSettingsModel copyWith({
    bool? crashlyticsEnabled,
    bool? analyticsEnabled,
    bool? debugMode,
    String? themeMode,
    String? locale,
    bool? notificationsEnabled,
    bool? biometricAuthEnabled,
    int? sessionTimeoutMinutes,
  }) {
    return AppSettingsModel(
      crashlyticsEnabled: crashlyticsEnabled ?? this.crashlyticsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      debugMode: debugMode ?? this.debugMode,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricAuthEnabled: biometricAuthEnabled ?? this.biometricAuthEnabled,
      sessionTimeoutMinutes:
          sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'crashlyticsEnabled': crashlyticsEnabled,
      'analyticsEnabled': analyticsEnabled,
      'debugMode': debugMode,
      'themeMode': themeMode,
      'locale': locale,
      'notificationsEnabled': notificationsEnabled,
      'biometricAuthEnabled': biometricAuthEnabled,
      'sessionTimeoutMinutes': sessionTimeoutMinutes,
    };
  }

  /// Create from JSON
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      crashlyticsEnabled: json['crashlyticsEnabled'] as bool? ?? true,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
      debugMode: json['debugMode'] as bool? ?? false,
      themeMode: json['themeMode'] as String? ?? 'system',
      locale: json['locale'] as String? ?? 'en',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      biometricAuthEnabled: json['biometricAuthEnabled'] as bool? ?? true,
      sessionTimeoutMinutes: json['sessionTimeoutMinutes'] as int? ?? 30,
    );
  }

  /// Validate theme mode value
  bool get isValidThemeMode {
    return ['light', 'dark', 'system'].contains(themeMode);
  }

  /// Validate session timeout range
  bool get isValidSessionTimeout {
    return sessionTimeoutMinutes >= 5 && sessionTimeoutMinutes <= 120;
  }

  /// Validate locale format (basic validation)
  bool get isValidLocale {
    return locale.isNotEmpty && locale.length >= 2;
  }

  /// Validate all settings
  bool get isValid {
    return isValidThemeMode && isValidSessionTimeout && isValidLocale;
  }

  /// Get validation errors
  List<String> get validationErrors {
    final errors = <String>[];

    if (!isValidThemeMode) {
      errors.add('Theme mode must be one of: light, dark, system');
    }

    if (!isValidSessionTimeout) {
      errors.add('Session timeout must be between 5 and 120 minutes');
    }

    if (!isValidLocale) {
      errors.add('Locale must be a valid language code');
    }

    return errors;
  }

  /// Create default settings
  factory AppSettingsModel.defaultSettings() {
    return const AppSettingsModel();
  }

  /// Create settings optimized for privacy
  factory AppSettingsModel.privacyOptimized() {
    return const AppSettingsModel(
      crashlyticsEnabled: false,
      analyticsEnabled: false,
      debugMode: false,
      themeMode: 'system',
      locale: 'en',
      notificationsEnabled: false,
      biometricAuthEnabled: true,
      sessionTimeoutMinutes: 15,
    );
  }

  /// Create settings optimized for development
  factory AppSettingsModel.developmentMode() {
    return const AppSettingsModel(
      crashlyticsEnabled: true,
      analyticsEnabled: false,
      debugMode: true,
      themeMode: 'system',
      locale: 'en',
      notificationsEnabled: true,
      biometricAuthEnabled: false,
      sessionTimeoutMinutes: 60,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettingsModel &&
        other.crashlyticsEnabled == crashlyticsEnabled &&
        other.analyticsEnabled == analyticsEnabled &&
        other.debugMode == debugMode &&
        other.themeMode == themeMode &&
        other.locale == locale &&
        other.notificationsEnabled == notificationsEnabled &&
        other.biometricAuthEnabled == biometricAuthEnabled &&
        other.sessionTimeoutMinutes == sessionTimeoutMinutes;
  }

  @override
  int get hashCode {
    return Object.hash(
      crashlyticsEnabled,
      analyticsEnabled,
      debugMode,
      themeMode,
      locale,
      notificationsEnabled,
      biometricAuthEnabled,
      sessionTimeoutMinutes,
    );
  }

  @override
  String toString() {
    return 'AppSettingsModel('
        'crashlyticsEnabled: $crashlyticsEnabled, '
        'analyticsEnabled: $analyticsEnabled, '
        'debugMode: $debugMode, '
        'themeMode: $themeMode, '
        'locale: $locale, '
        'notificationsEnabled: $notificationsEnabled, '
        'biometricAuthEnabled: $biometricAuthEnabled, '
        'sessionTimeoutMinutes: $sessionTimeoutMinutes'
        ')';
  }
}
