/// Application settings entity
class AppSettings {
  final bool crashlyticsEnabled;
  final bool analyticsEnabled;
  final bool debugMode;
  final String themeMode; // 'light', 'dark', 'system'
  final String locale;
  final bool notificationsEnabled;
  final bool biometricAuthEnabled;
  final int sessionTimeoutMinutes;

  const AppSettings({
    this.crashlyticsEnabled = true,
    this.analyticsEnabled = true,
    this.debugMode = false,
    this.themeMode = 'system',
    this.locale = 'en',
    this.notificationsEnabled = true,
    this.biometricAuthEnabled = true,
    this.sessionTimeoutMinutes = 30,
  });

  /// Create a copy of this AppSettings with some fields replaced
  AppSettings copyWith({
    bool? crashlyticsEnabled,
    bool? analyticsEnabled,
    bool? debugMode,
    String? themeMode,
    String? locale,
    bool? notificationsEnabled,
    bool? biometricAuthEnabled,
    int? sessionTimeoutMinutes,
  }) {
    return AppSettings(
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
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
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
    return 'AppSettings('
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
