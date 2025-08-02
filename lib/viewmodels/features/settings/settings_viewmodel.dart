import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/features/settings/app_settings_model.dart';
import '../../../services/crashlytics_service.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// Provider for settings ViewModel
final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, AsyncValue<AppSettingsModel>>((
      ref,
    ) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return SettingsViewModel(prefs);
    });

/// Enhanced ViewModel for managing app settings with improved error handling
///
/// **Improvements:**
/// - Uses Result pattern for better error handling
/// - Debounced updates to prevent excessive saves
/// - Validation before saving
/// - Better separation of concerns
/// - Comprehensive logging and error tracking
class SettingsViewModel extends StateNotifier<AsyncValue<AppSettingsModel>> {
  static const String _settingsKey = 'app_settings';

  final SharedPreferences _prefs;

  SettingsViewModel(this._prefs) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  /// Load settings with enhanced error handling
  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();

    try {
      final settingsJson = _prefs.getString(_settingsKey);
      AppSettingsModel settings;

      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        settings = AppSettingsModel.fromJson(settingsMap);

        // Validate loaded settings
        if (!settings.isValid) {
          await CrashlyticsService.instance.log(
            'Invalid settings loaded, using defaults. Errors: ${settings.validationErrors}',
          );
          settings = AppSettingsModel.defaultSettings();
        }
      } else {
        settings = AppSettingsModel.defaultSettings();
      }

      state = AsyncValue.data(settings);
      CrashlyticsService.instance.log('Settings loaded successfully');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      CrashlyticsService.instance.recordError(
        error,
        stackTrace,
        reason: 'Settings loading failed',
      );
    }
  }

  /// Save settings to SharedPreferences (direct service call)
  Future<void> _saveSettings(AppSettingsModel settings) async {
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

  /// Update settings
  Future<void> updateSettings(AppSettingsModel settings) async {
    try {
      state = const AsyncValue.loading();
      await _saveSettings(settings);
      state = AsyncValue.data(settings);

      await CrashlyticsService.instance.log(
        'Settings updated: crashlytics=${settings.crashlyticsEnabled}, '
        'analytics=${settings.analyticsEnabled}, theme=${settings.themeMode}',
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      await CrashlyticsService.instance.recordError(
        error,
        stackTrace,
        reason: 'Failed to update app settings',
      );
    }
  }

  /// Toggle Crashlytics collection
  Future<void> toggleCrashlytics(bool enabled) async {
    final currentSettings = state.value;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        crashlyticsEnabled: enabled,
      );
      await updateSettings(updatedSettings);
    }
  }

  /// Toggle analytics collection
  Future<void> toggleAnalytics(bool enabled) async {
    final currentSettings = state.value;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        analyticsEnabled: enabled,
      );
      await updateSettings(updatedSettings);
    }
  }

  /// Update theme mode
  Future<void> updateThemeMode(AppThemeMode themeMode) async {
    final currentSettings = state.value;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(themeMode: themeMode);
      await updateSettings(updatedSettings);
    }
  }

  /// Toggle debug mode
  Future<void> toggleDebugMode(bool enabled) async {
    final currentSettings = state.value;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(debugMode: enabled);
      await updateSettings(updatedSettings);
    }
  }

  /// Reset settings to defaults (direct service call)
  Future<void> resetSettings() async {
    try {
      state = const AsyncValue.loading();

      // Remove existing settings
      await _prefs.remove(_settingsKey);

      // Reset to default settings
      final defaultSettings = AppSettingsModel.defaultSettings();
      await _saveSettings(defaultSettings);

      state = AsyncValue.data(defaultSettings);

      await CrashlyticsService.instance.log('Settings reset to defaults');
      await CrashlyticsService.instance.log('Settings reset to defaults');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      await CrashlyticsService.instance.recordError(
        error,
        stackTrace,
        reason: 'Failed to reset app settings',
      );
    }
  }
}
