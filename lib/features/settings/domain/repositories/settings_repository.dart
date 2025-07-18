import '../entities/app_settings.dart';

/// Repository interface for managing application settings
abstract class SettingsRepository {
  /// Get current application settings
  Future<AppSettings> getSettings();

  /// Save application settings
  Future<void> saveSettings(AppSettings settings);

  /// Reset settings to defaults
  Future<void> resetSettings();
}
