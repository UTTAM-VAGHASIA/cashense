import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Service for handling localization, formatting, and RTL support
class LocalizationService {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English (United States)
    Locale('es', 'ES'), // Spanish (Spain)
    Locale('fr', 'FR'), // French (France)
    Locale('de', 'DE'), // German (Germany)
    Locale('ar', 'SA'), // Arabic (Saudi Arabia) - RTL
    Locale('hi', 'IN'), // Hindi (India)
    Locale('zh', 'CN'), // Chinese (China)
  ];

  /// Map of language codes to their display names in their native language
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'ar': 'العربية',
    'hi': 'हिन्दी',
    'zh': '中文',
  };

  /// Map of language codes to their display names in English
  static const Map<String, String> languageNamesEnglish = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'ar': 'Arabic',
    'hi': 'Hindi',
    'zh': 'Chinese',
  };

  /// RTL (Right-to-Left) language codes
  static const Set<String> rtlLanguages = {
    'ar', // Arabic
    'he', // Hebrew
    'fa', // Persian/Farsi
    'ur', // Urdu
  };

  /// Check if a locale uses RTL text direction
  static bool isRTL(Locale locale) {
    return rtlLanguages.contains(locale.languageCode);
  }

  /// Get text direction for a locale
  static ui.TextDirection getTextDirection(Locale locale) {
    return isRTL(locale) ? ui.TextDirection.rtl : ui.TextDirection.ltr;
  }

  /// Get the display name of a language in its native script
  static String getLanguageDisplayName(String languageCode) {
    return languageNames[languageCode] ?? languageCode.toUpperCase();
  }

  /// Get the display name of a language in English
  static String getLanguageDisplayNameEnglish(String languageCode) {
    return languageNamesEnglish[languageCode] ?? languageCode.toUpperCase();
  }

  /// Find the best matching supported locale for a given locale
  static Locale? findBestSupportedLocale(Locale? locale) {
    if (locale == null) return supportedLocales.first;

    // Try exact match first
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }

    // Try language code match
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }

    // Return default locale
    return supportedLocales.first;
  }

  /// Get locale from language code
  static Locale getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'en':
        return const Locale('en', 'US');
      case 'es':
        return const Locale('es', 'ES');
      case 'fr':
        return const Locale('fr', 'FR');
      case 'de':
        return const Locale('de', 'DE');
      case 'ar':
        return const Locale('ar', 'SA');
      case 'hi':
        return const Locale('hi', 'IN');
      case 'zh':
        return const Locale('zh', 'CN');
      default:
        return const Locale('en', 'US');
    }
  }

  /// Format currency amount with proper locale formatting
  static String formatCurrency(
    double amount,
    String currencyCode,
    Locale locale,
  ) {
    try {
      final formatter = NumberFormat.currency(
        locale: locale.toString(),
        symbol: _getCurrencySymbol(currencyCode),
        decimalDigits: _getCurrencyDecimalPlaces(currencyCode),
      );
      return formatter.format(amount);
    } catch (e) {
      // Fallback to simple formatting
      return '$currencyCode ${amount.toStringAsFixed(2)}';
    }
  }

  /// Format currency amount without symbol
  static String formatCurrencyCompact(
    double amount,
    String currencyCode,
    Locale locale,
  ) {
    try {
      final formatter = NumberFormat.currency(
        locale: locale.toString(),
        symbol: '',
        decimalDigits: _getCurrencyDecimalPlaces(currencyCode),
      );
      return formatter.format(amount).trim();
    } catch (e) {
      return amount.toStringAsFixed(2);
    }
  }

  /// Format number with locale-specific formatting
  static String formatNumber(double number, Locale locale) {
    try {
      final formatter = NumberFormat('#,##0.##', locale.toString());
      return formatter.format(number);
    } catch (e) {
      return number.toString();
    }
  }

  /// Format percentage with locale-specific formatting
  static String formatPercentage(double percentage, Locale locale) {
    try {
      final formatter = NumberFormat.percentPattern(locale.toString());
      return formatter.format(percentage / 100);
    } catch (e) {
      return '${percentage.toStringAsFixed(1)}%';
    }
  }

  /// Format date with locale-specific formatting
  static String formatDate(DateTime date, Locale locale) {
    try {
      final formatter = DateFormat.yMMMd(locale.toString());
      return formatter.format(date);
    } catch (e) {
      return DateFormat.yMMMd().format(date);
    }
  }

  /// Format date and time with locale-specific formatting
  static String formatDateTime(DateTime dateTime, Locale locale) {
    try {
      final formatter = DateFormat.yMMMd(locale.toString()).add_jm();
      return formatter.format(dateTime);
    } catch (e) {
      return DateFormat.yMMMd().add_jm().format(dateTime);
    }
  }

  /// Format time with locale-specific formatting
  static String formatTime(DateTime time, Locale locale) {
    try {
      final formatter = DateFormat.jm(locale.toString());
      return formatter.format(time);
    } catch (e) {
      return DateFormat.jm().format(time);
    }
  }

  /// Format date in short format (e.g., 12/31/2023)
  static String formatDateShort(DateTime date, Locale locale) {
    try {
      final formatter = DateFormat.yMd(locale.toString());
      return formatter.format(date);
    } catch (e) {
      return DateFormat.yMd().format(date);
    }
  }

  /// Format date in medium format (e.g., Dec 31, 2023)
  static String formatDateMedium(DateTime date, Locale locale) {
    try {
      final formatter = DateFormat.yMMMd(locale.toString());
      return formatter.format(date);
    } catch (e) {
      return DateFormat.yMMMd().format(date);
    }
  }

  /// Format date in long format (e.g., December 31, 2023)
  static String formatDateLong(DateTime date, Locale locale) {
    try {
      final formatter = DateFormat.yMMMMd(locale.toString());
      return formatter.format(date);
    } catch (e) {
      return DateFormat.yMMMMd().format(date);
    }
  }

  /// Format relative time (e.g., "2 hours ago", "yesterday")
  static String formatRelativeTime(DateTime dateTime, Locale locale) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return formatDate(dateTime, locale);
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return _getLocalizedString('yesterday', locale);
      } else {
        return '${difference.inDays} ${_getLocalizedString('daysAgo', locale)}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${_getLocalizedString('hoursAgo', locale)}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${_getLocalizedString('minutesAgo', locale)}';
    } else {
      return _getLocalizedString('justNow', locale);
    }
  }

  /// Get currency symbol for a currency code
  static String _getCurrencySymbol(String currencyCode) {
    const currencySymbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'INR': '₹',
      'SAR': 'ر.س',
      'AED': 'د.إ',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'CHF',
      'SEK': 'kr',
      'NOK': 'kr',
      'DKK': 'kr',
      'PLN': 'zł',
      'CZK': 'Kč',
      'HUF': 'Ft',
      'RUB': '₽',
      'BRL': 'R\$',
      'MXN': '\$',
      'ZAR': 'R',
      'KRW': '₩',
      'SGD': 'S\$',
      'HKD': 'HK\$',
      'NZD': 'NZ\$',
      'THB': '฿',
      'MYR': 'RM',
      'PHP': '₱',
      'IDR': 'Rp',
      'VND': '₫',
      'TRY': '₺',
      'EGP': 'ج.م',
      'MAD': 'د.م.',
      'NGN': '₦',
      'KES': 'KSh',
      'GHS': '₵',
      'UGX': 'USh',
      'TZS': 'TSh',
      'ZMW': 'ZK',
      'BWP': 'P',
      'MUR': '₨',
      'SCR': '₨',
    };

    return currencySymbols[currencyCode.toUpperCase()] ?? currencyCode;
  }

  /// Get decimal places for a currency
  static int _getCurrencyDecimalPlaces(String currencyCode) {
    const zeroDecimalCurrencies = {
      'JPY',
      'KRW',
      'VND',
      'CLP',
      'ISK',
      'UGX',
      'RWF',
      'XAF',
      'XOF',
      'XPF',
    };

    const threeDecimalCurrencies = {
      'BHD',
      'IQD',
      'JOD',
      'KWD',
      'LYD',
      'OMR',
      'TND',
    };

    final code = currencyCode.toUpperCase();
    if (zeroDecimalCurrencies.contains(code)) {
      return 0;
    } else if (threeDecimalCurrencies.contains(code)) {
      return 3;
    } else {
      return 2;
    }
  }

  /// Get localized string (fallback implementation)
  static String _getLocalizedString(String key, Locale locale) {
    // This is a simplified implementation
    // In a real app, you would use the AppLocalizations class
    switch (key) {
      case 'yesterday':
        switch (locale.languageCode) {
          case 'es':
            return 'ayer';
          case 'fr':
            return 'hier';
          case 'de':
            return 'gestern';
          case 'ar':
            return 'أمس';
          case 'hi':
            return 'कल';
          case 'zh':
            return '昨天';
          default:
            return 'yesterday';
        }
      case 'daysAgo':
        switch (locale.languageCode) {
          case 'es':
            return 'días atrás';
          case 'fr':
            return 'jours';
          case 'de':
            return 'Tage her';
          case 'ar':
            return 'أيام مضت';
          case 'hi':
            return 'दिन पहले';
          case 'zh':
            return '天前';
          default:
            return 'days ago';
        }
      case 'hoursAgo':
        switch (locale.languageCode) {
          case 'es':
            return 'horas atrás';
          case 'fr':
            return 'heures';
          case 'de':
            return 'Stunden her';
          case 'ar':
            return 'ساعات مضت';
          case 'hi':
            return 'घंटे पहले';
          case 'zh':
            return '小时前';
          default:
            return 'hours ago';
        }
      case 'minutesAgo':
        switch (locale.languageCode) {
          case 'es':
            return 'minutos atrás';
          case 'fr':
            return 'minutes';
          case 'de':
            return 'Minuten her';
          case 'ar':
            return 'دقائق مضت';
          case 'hi':
            return 'मिनट पहले';
          case 'zh':
            return '分钟前';
          default:
            return 'minutes ago';
        }
      case 'justNow':
        switch (locale.languageCode) {
          case 'es':
            return 'ahora mismo';
          case 'fr':
            return 'à l\'instant';
          case 'de':
            return 'gerade eben';
          case 'ar':
            return 'الآن';
          case 'hi':
            return 'अभी';
          case 'zh':
            return '刚刚';
          default:
            return 'just now';
        }
      default:
        return key;
    }
  }

  /// Parse date string with locale-specific parsing
  static DateTime? parseDate(String dateString, Locale locale) {
    try {
      final formatter = DateFormat.yMd(locale.toString());
      return formatter.parse(dateString);
    } catch (e) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
  }

  /// Parse number string with locale-specific parsing
  static double? parseNumber(String numberString, Locale locale) {
    try {
      final formatter = NumberFormat('#,##0.##', locale.toString());
      return formatter.parse(numberString).toDouble();
    } catch (e) {
      try {
        return double.parse(numberString.replaceAll(',', ''));
      } catch (e) {
        return null;
      }
    }
  }

  /// Get first day of week for locale (0 = Sunday, 1 = Monday)
  static int getFirstDayOfWeek(Locale locale) {
    // Most countries use Monday as first day of week
    // US, Canada, and some others use Sunday
    const sundayFirstCountries = {'US', 'CA', 'MX', 'BR', 'AU', 'NZ', 'ZA'};

    if (sundayFirstCountries.contains(locale.countryCode)) {
      return 0; // Sunday
    } else {
      return 1; // Monday
    }
  }

  /// Get weekend days for locale
  static Set<int> getWeekendDays(Locale locale) {
    // Most countries: Saturday (6) and Sunday (0)
    // Some Middle Eastern countries: Friday (5) and Saturday (6)
    const fridaySaturdayWeekendCountries = {'SA', 'AE', 'BH', 'KW', 'OM', 'QA'};

    if (fridaySaturdayWeekendCountries.contains(locale.countryCode)) {
      return {5, 6}; // Friday and Saturday
    } else {
      return {0, 6}; // Sunday and Saturday
    }
  }

  /// Check if current locale uses 24-hour time format
  static bool uses24HourFormat(Locale locale) {
    // US typically uses 12-hour format, most others use 24-hour
    const twelveHourCountries = {'US', 'CA', 'AU', 'NZ', 'PH'};

    return !twelveHourCountries.contains(locale.countryCode);
  }
}
