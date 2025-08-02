import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localization_service.dart';

/// Provider for managing the current locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Notifier for managing locale state
class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'selected_locale';

  LocaleNotifier() : super(LocalizationService.supportedLocales.first) {
    _loadSavedLocale();
  }

  /// Load the saved locale from shared preferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_localeKey);

      if (savedLanguageCode != null) {
        final locale = LocalizationService.getLocaleFromLanguageCode(
          savedLanguageCode,
        );
        state = locale;
      } else {
        // Use system locale if available and supported
        final systemLocale = ui.PlatformDispatcher.instance.locale;
        final bestMatch = LocalizationService.findBestSupportedLocale(
          systemLocale,
        );
        if (bestMatch != null) {
          state = bestMatch;
        }
      }
    } catch (e) {
      // If loading fails, keep the default locale
    }
  }

  /// Change the current locale
  Future<void> setLocale(Locale locale) async {
    if (!LocalizationService.supportedLocales.contains(locale)) {
      throw ArgumentError('Unsupported locale: $locale');
    }

    state = locale;
    await _saveLocale(locale);
  }

  /// Change locale by language code
  Future<void> setLanguage(String languageCode) async {
    final locale = LocalizationService.getLocaleFromLanguageCode(languageCode);
    await setLocale(locale);
  }

  /// Save the current locale to shared preferences
  Future<void> _saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      // If saving fails, continue with the locale change
    }
  }

  /// Reset to system locale
  Future<void> resetToSystemLocale() async {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    final bestMatch = LocalizationService.findBestSupportedLocale(systemLocale);
    if (bestMatch != null) {
      await setLocale(bestMatch);
    }
  }

  /// Get the current language code
  String get currentLanguageCode => state.languageCode;

  /// Get the current language display name
  String get currentLanguageDisplayName {
    return LocalizationService.getLanguageDisplayName(state.languageCode);
  }

  /// Check if current locale is RTL
  bool get isRTL => LocalizationService.isRTL(state);

  /// Get text direction for current locale
  ui.TextDirection get textDirection =>
      LocalizationService.getTextDirection(state);
}

/// Provider for checking if current locale is RTL
final isRTLProvider = Provider<bool>((ref) {
  final locale = ref.watch(localeProvider);
  return LocalizationService.isRTL(locale);
});

/// Provider for getting text direction
final textDirectionProvider = Provider<ui.TextDirection>((ref) {
  final locale = ref.watch(localeProvider);
  return LocalizationService.getTextDirection(locale);
});

/// Provider for getting current language display name
final currentLanguageDisplayNameProvider = Provider<String>((ref) {
  final locale = ref.watch(localeProvider);
  return LocalizationService.getLanguageDisplayName(locale.languageCode);
});

/// Provider for getting all supported locales with their display names
final supportedLocalesWithNamesProvider = Provider<List<LocaleInfo>>((ref) {
  return LocalizationService.supportedLocales.map((locale) {
    return LocaleInfo(
      locale: locale,
      displayName: LocalizationService.getLanguageDisplayName(
        locale.languageCode,
      ),
      displayNameEnglish: LocalizationService.getLanguageDisplayNameEnglish(
        locale.languageCode,
      ),
      isRTL: LocalizationService.isRTL(locale),
    );
  }).toList();
});

/// Information about a locale
class LocaleInfo {
  const LocaleInfo({
    required this.locale,
    required this.displayName,
    required this.displayNameEnglish,
    required this.isRTL,
  });

  final Locale locale;
  final String displayName;
  final String displayNameEnglish;
  final bool isRTL;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocaleInfo && other.locale == locale;
  }

  @override
  int get hashCode => locale.hashCode;

  @override
  String toString() {
    return 'LocaleInfo(locale: $locale, displayName: $displayName, isRTL: $isRTL)';
  }
}
