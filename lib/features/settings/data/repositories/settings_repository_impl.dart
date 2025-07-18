import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../../../shared/services/crashlytics_service.dart';

/// Implementation of settings repository using SharedPreferences
class SettingsRepositoryImpl implements SettingsRepository {
  static const String _settingsKey = 'app_settings';

  final SharedPreferences _prefs;

  SettingsRepositoryImpl(this._prefs);

  @override
  Future<AppSettings> getSettings() async {
    try {
      final settingsJson = _prefs.getString(_settingsKey);
      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        return AppSettings.fromJson(settingsMap);
      }
    } catch (e) {
      await CrashlyticsService.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to load settings from SharedPreferences',
      );
    }

    // Return default settings if loading fails
    return const AppSettings();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    try {
      final settingsJson = json.encode(settings.toJson());
      await _prefs.setString(_settingsKey, settingsJson);

      // Apply Crashlytics setting immediately
      await CrashlyticsService.instance.setCrashlyticsCollectionEnabled(
        settings.crashlyticsEnabled,
      );

      await CrashlyticsService.instance.log('Settings updated');
    } catch (e) {
      await CrashlyticsService.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to save settings to SharedPreferences',
      );
      rethrow;
    }
  }

  @override
  Future<void> resetSettings() async {
    try {
      await _prefs.remove(_settingsKey);

      // Reset to default settings
      const defaultSettings = AppSettings();
      await saveSettings(defaultSettings);

      await CrashlyticsService.instance.log('Settings reset to defaults');
    } catch (e) {
      await CrashlyticsService.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to reset settings',
      );
      rethrow;
    }
  }
}
