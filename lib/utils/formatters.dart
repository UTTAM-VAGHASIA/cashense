import 'dart:ui';

import 'package:intl/intl.dart';

import '../app/localization/localization_service.dart';

/// Comprehensive formatting utilities for financial applications
class Formatters {
  /// Format currency with advanced options
  static String formatCurrencyAdvanced({
    required double amount,
    required String currencyCode,
    required Locale locale,
    bool showSymbol = true,
    bool showCode = false,
    int? decimalPlaces,
    bool compact = false,
  }) {
    try {
      final places = decimalPlaces ?? _getCurrencyDecimalPlaces(currencyCode);

      if (compact && amount.abs() >= 1000) {
        return _formatCompactCurrency(amount, currencyCode, locale, showSymbol);
      }

      String symbol = '';
      if (showSymbol) {
        symbol = _getCurrencySymbol(currencyCode);
      }
      if (showCode) {
        symbol = showSymbol ? '$symbol $currencyCode' : currencyCode;
      }

      final formatter = NumberFormat.currency(
        locale: locale.toString(),
        symbol: symbol,
        decimalDigits: places,
      );

      return formatter.format(amount);
    } catch (e) {
      return '$currencyCode ${amount.toStringAsFixed(decimalPlaces ?? 2)}';
    }
  }

  /// Format currency in compact form (e.g., $1.2K, $1.5M)
  static String _formatCompactCurrency(
    double amount,
    String currencyCode,
    Locale locale,
    bool showSymbol,
  ) {
    final symbol = showSymbol ? _getCurrencySymbol(currencyCode) : '';

    if (amount.abs() >= 1000000000) {
      return '$symbol${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount.abs() >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return LocalizationService.formatCurrency(amount, currencyCode, locale);
    }
  }

  /// Format financial amounts with proper grouping and precision
  static String formatFinancialAmount(
    double amount,
    Locale locale, {
    int decimalPlaces = 2,
    bool showPositiveSign = false,
  }) {
    try {
      final formatter = NumberFormat(
        '#,##0.${'0' * decimalPlaces}',
        locale.toString(),
      );
      final formatted = formatter.format(amount);

      if (showPositiveSign && amount > 0) {
        return '+$formatted';
      }

      return formatted;
    } catch (e) {
      return amount.toStringAsFixed(decimalPlaces);
    }
  }

  /// Format percentage with locale-specific formatting and options
  static String formatPercentageAdvanced(
    double percentage,
    Locale locale, {
    int decimalPlaces = 1,
    bool showPositiveSign = false,
  }) {
    try {
      final formatter = NumberFormat.percentPattern(locale.toString());
      formatter.minimumFractionDigits = decimalPlaces;
      formatter.maximumFractionDigits = decimalPlaces;

      final formatted = formatter.format(percentage / 100);

      if (showPositiveSign && percentage > 0) {
        return '+$formatted';
      }

      return formatted;
    } catch (e) {
      final sign = showPositiveSign && percentage > 0 ? '+' : '';
      return '$sign${percentage.toStringAsFixed(decimalPlaces)}%';
    }
  }

  /// Format date range
  static String formatDateRange(
    DateTime startDate,
    DateTime endDate,
    Locale locale,
  ) {
    try {
      final formatter = DateFormat.yMMMd(locale.toString());

      if (startDate.year == endDate.year) {
        if (startDate.month == endDate.month) {
          // Same month: "Jan 1-15, 2023"
          final monthDay = DateFormat.MMMd(locale.toString());
          final day = DateFormat.d(locale.toString());
          return '${monthDay.format(startDate)}-${day.format(endDate)}, ${startDate.year}';
        } else {
          // Same year: "Jan 1 - Feb 15, 2023"
          final monthDay = DateFormat.MMMd(locale.toString());
          return '${monthDay.format(startDate)} - ${monthDay.format(endDate)}, ${startDate.year}';
        }
      } else {
        // Different years: "Jan 1, 2023 - Feb 15, 2024"
        return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
      }
    } catch (e) {
      return '${LocalizationService.formatDate(startDate, locale)} - ${LocalizationService.formatDate(endDate, locale)}';
    }
  }

  /// Format duration in human-readable form
  static String formatDuration(Duration duration, Locale locale) {
    if (duration.inDays > 0) {
      return _pluralize(duration.inDays, 'day', 'days', locale);
    } else if (duration.inHours > 0) {
      return _pluralize(duration.inHours, 'hour', 'hours', locale);
    } else if (duration.inMinutes > 0) {
      return _pluralize(duration.inMinutes, 'minute', 'minutes', locale);
    } else {
      return _pluralize(duration.inSeconds, 'second', 'seconds', locale);
    }
  }

  /// Format file size in human-readable form
  static String formatFileSize(int bytes, Locale locale) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = bytes.toDouble();
    var suffixIndex = 0;

    while (size >= 1024 && suffixIndex < suffixes.length - 1) {
      size /= 1024;
      suffixIndex++;
    }

    final formatter = NumberFormat('#,##0.#', locale.toString());
    return '${formatter.format(size)} ${suffixes[suffixIndex]}';
  }

  /// Format ordinal numbers (1st, 2nd, 3rd, etc.)
  static String formatOrdinal(int number, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        if (number % 100 >= 11 && number % 100 <= 13) {
          return '${number}th';
        }
        switch (number % 10) {
          case 1:
            return '${number}st';
          case 2:
            return '${number}nd';
          case 3:
            return '${number}rd';
          default:
            return '${number}th';
        }
      case 'es':
        return number == 1 ? '1º' : '$numberº';
      case 'fr':
        return number == 1 ? '1er' : '${number}e';
      case 'de':
        return '$number.';
      default:
        return number.toString();
    }
  }

  /// Format phone number with locale-specific formatting
  static String formatPhoneNumber(String phoneNumber, Locale locale) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) return phoneNumber;

    switch (locale.countryCode) {
      case 'US':
      case 'CA':
        if (digits.length == 10) {
          return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
        } else if (digits.length == 11 && digits.startsWith('1')) {
          return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
        }
        break;
      case 'GB':
        if (digits.length == 11 && digits.startsWith('0')) {
          return '${digits.substring(0, 5)} ${digits.substring(5)}';
        }
        break;
      case 'DE':
        if (digits.length >= 10) {
          return '+49 ${digits.substring(2, 5)} ${digits.substring(5)}';
        }
        break;
      case 'FR':
        if (digits.length == 10) {
          return '${digits.substring(0, 2)} ${digits.substring(2, 4)} ${digits.substring(4, 6)} ${digits.substring(6, 8)} ${digits.substring(8)}';
        }
        break;
    }

    // Fallback: just add spaces every 3-4 digits
    if (digits.length > 6) {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    } else if (digits.length > 3) {
      return '${digits.substring(0, 3)} ${digits.substring(3)}';
    }

    return digits;
  }

  /// Format credit card number with masking
  static String formatCreditCard(String cardNumber, {bool mask = true}) {
    final digits = cardNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.isEmpty) return cardNumber;

    String formatted = '';
    for (int i = 0; i < digits.length; i += 4) {
      if (i > 0) formatted += ' ';
      final chunk = digits.substring(i, (i + 4).clamp(0, digits.length));

      if (mask && i < digits.length - 4) {
        formatted += '****';
      } else {
        formatted += chunk;
      }
    }

    return formatted;
  }

  /// Helper method for pluralization
  static String _pluralize(
    int count,
    String singular,
    String plural,
    Locale locale,
  ) {
    final countStr = LocalizationService.formatNumber(count.toDouble(), locale);

    switch (locale.languageCode) {
      case 'en':
        return '$countStr ${count == 1 ? singular : plural}';
      case 'es':
        // Spanish pluralization rules
        final word = count == 1 ? singular : plural;
        return '$countStr $word';
      case 'fr':
        // French pluralization rules
        final word = count <= 1 ? singular : plural;
        return '$countStr $word';
      case 'de':
        // German pluralization rules
        final word = count == 1 ? singular : plural;
        return '$countStr $word';
      case 'ar':
        // Arabic has complex pluralization rules
        String word;
        if (count == 0) {
          word = plural; // No items
        } else if (count == 1) {
          word = singular; // One item
        } else if (count == 2) {
          word = plural; // Two items (dual)
        } else if (count >= 3 && count <= 10) {
          word = plural; // Few items
        } else {
          word = plural; // Many items
        }
        return '$countStr $word';
      default:
        return '$countStr ${count == 1 ? singular : plural}';
    }
  }

  /// Format account number with masking
  static String formatAccountNumber(String accountNumber, {bool mask = true}) {
    if (accountNumber.length <= 4) return accountNumber;

    if (mask) {
      final visiblePart = accountNumber.substring(accountNumber.length - 4);
      final maskedPart = '*' * (accountNumber.length - 4);
      return '$maskedPart$visiblePart';
    }

    return accountNumber;
  }

  /// Format IBAN with proper spacing
  static String formatIBAN(String iban) {
    final cleanIban = iban.replaceAll(RegExp(r'\s'), '').toUpperCase();

    if (cleanIban.isEmpty) return iban;

    String formatted = '';
    for (int i = 0; i < cleanIban.length; i += 4) {
      if (i > 0) formatted += ' ';
      formatted += cleanIban.substring(i, (i + 4).clamp(0, cleanIban.length));
    }

    return formatted;
  }

  /// Format routing number
  static String formatRoutingNumber(String routingNumber) {
    final digits = routingNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 9) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    }

    return routingNumber;
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
}
