import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../../../shared/services/crashlytics_service.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// Provider for settings repository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepositoryImpl(prefs);
});

/// Provider for current app settings
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AsyncValue<AppSettings>>((ref) {
      final repository = ref.watch(settingsRepositoryProvider);
      return AppSettingsNotifier(repository);
    });

/// State notifier for managing app settings
class AppSettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final SettingsRepository _repository;

  AppSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  /// Load settings from repository
  Future<void> _loadSettings() async {
    try {
      state = const AsyncValue.loading();
      final settings = await _repository.getSettings();
      state = AsyncValue.data(settings);

      await CrashlyticsService.instance.log('Settings loaded successfully');
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      await CrashlyticsService.instance.recordError(
        error,
        stackTrace,
        reason: 'Failed to load app settings',
      );
    }
  }

  /// Update settings
  Future<void> updateSettings(AppSettings settings) async {
    try {
      state = const AsyncValue.loading();
      await _repository.saveSettings(settings);
      state = AsyncValue.data(settings);

      await CrashlyticsService.instance.recordUserAction(
        'settings_updated',
        parameters: {
          'crashlytics_enabled': settings.crashlyticsEnabled,
          'analytics_enabled': settings.analyticsEnabled,
          'theme_mode': settings.themeMode,
        },
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
  Future<void> updateThemeMode(String themeMode) async {
    final currentSettings = state.value;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(themeMode: themeMode);
      await updateSettings(updatedSettings);
    }
  }

  /// Reset settings to defaults
  Future<void> resetSettings() async {
    try {
      state = const AsyncValue.loading();
      await _repository.resetSettings();
      final settings = await _repository.getSettings();
      state = AsyncValue.data(settings);

      await CrashlyticsService.instance.recordUserAction('settings_reset');
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
