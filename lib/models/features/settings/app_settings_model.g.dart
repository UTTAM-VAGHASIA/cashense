// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsModelImpl _$$AppSettingsModelImplFromJson(
  Map<String, dynamic> json,
) => _$AppSettingsModelImpl(
  crashlyticsEnabled: json['crashlytics_enabled'] as bool? ?? true,
  analyticsEnabled: json['analytics_enabled'] as bool? ?? true,
  debugMode: json['debug_mode'] as bool? ?? false,
  themeMode:
      $enumDecodeNullable(_$AppThemeModeEnumMap, json['theme_mode']) ??
      AppThemeMode.system,
  locale: json['locale'] as String? ?? 'en',
  notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
  biometricAuthEnabled: json['biometric_auth_enabled'] as bool? ?? true,
  sessionTimeoutMinutes:
      (json['session_timeout_minutes'] as num?)?.toInt() ?? 30,
);

Map<String, dynamic> _$$AppSettingsModelImplToJson(
  _$AppSettingsModelImpl instance,
) => <String, dynamic>{
  'crashlytics_enabled': instance.crashlyticsEnabled,
  'analytics_enabled': instance.analyticsEnabled,
  'debug_mode': instance.debugMode,
  'theme_mode': _$AppThemeModeEnumMap[instance.themeMode]!,
  'locale': instance.locale,
  'notifications_enabled': instance.notificationsEnabled,
  'biometric_auth_enabled': instance.biometricAuthEnabled,
  'session_timeout_minutes': instance.sessionTimeoutMinutes,
};

const _$AppThemeModeEnumMap = {
  AppThemeMode.light: 'light',
  AppThemeMode.dark: 'dark',
  AppThemeMode.system: 'system',
};
