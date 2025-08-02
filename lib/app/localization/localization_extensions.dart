import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'localization_service.dart';

/// Extension on BuildContext to provide easy access to localization
extension LocalizationExtensions on BuildContext {
  /// Get the current AppLocalizations instance
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Get the current locale
  Locale get locale => Localizations.localeOf(this);

  /// Check if current locale is RTL
  bool get isRTL => LocalizationService.isRTL(locale);

  /// Get text direction for current locale
  TextDirection get textDirection =>
      LocalizationService.getTextDirection(locale);

  /// Format currency with current locale
  String formatCurrency(double amount, String currencyCode) {
    return LocalizationService.formatCurrency(amount, currencyCode, locale);
  }

  /// Format currency without symbol with current locale
  String formatCurrencyCompact(double amount, String currencyCode) {
    return LocalizationService.formatCurrencyCompact(
      amount,
      currencyCode,
      locale,
    );
  }

  /// Format number with current locale
  String formatNumber(double number) {
    return LocalizationService.formatNumber(number, locale);
  }

  /// Format percentage with current locale
  String formatPercentage(double percentage) {
    return LocalizationService.formatPercentage(percentage, locale);
  }

  /// Format date with current locale
  String formatDate(DateTime date) {
    return LocalizationService.formatDate(date, locale);
  }

  /// Format date and time with current locale
  String formatDateTime(DateTime dateTime) {
    return LocalizationService.formatDateTime(dateTime, locale);
  }

  /// Format time with current locale
  String formatTime(DateTime time) {
    return LocalizationService.formatTime(time, locale);
  }

  /// Format date in short format with current locale
  String formatDateShort(DateTime date) {
    return LocalizationService.formatDateShort(date, locale);
  }

  /// Format date in medium format with current locale
  String formatDateMedium(DateTime date) {
    return LocalizationService.formatDateMedium(date, locale);
  }

  /// Format date in long format with current locale
  String formatDateLong(DateTime date) {
    return LocalizationService.formatDateLong(date, locale);
  }

  /// Format relative time with current locale
  String formatRelativeTime(DateTime dateTime) {
    return LocalizationService.formatRelativeTime(dateTime, locale);
  }

  /// Parse date string with current locale
  DateTime? parseDate(String dateString) {
    return LocalizationService.parseDate(dateString, locale);
  }

  /// Parse number string with current locale
  double? parseNumber(String numberString) {
    return LocalizationService.parseNumber(numberString, locale);
  }

  /// Get first day of week for current locale
  int get firstDayOfWeek => LocalizationService.getFirstDayOfWeek(locale);

  /// Get weekend days for current locale
  Set<int> get weekendDays => LocalizationService.getWeekendDays(locale);

  /// Check if current locale uses 24-hour time format
  bool get uses24HourFormat => LocalizationService.uses24HourFormat(locale);
}

/// Extension on DateTime to provide localized formatting
extension DateTimeLocalization on DateTime {
  /// Format this DateTime with the given locale
  String format(Locale locale) {
    return LocalizationService.formatDateTime(this, locale);
  }

  /// Format this DateTime as date only with the given locale
  String formatDate(Locale locale) {
    return LocalizationService.formatDate(this, locale);
  }

  /// Format this DateTime as time only with the given locale
  String formatTime(Locale locale) {
    return LocalizationService.formatTime(this, locale);
  }

  /// Format this DateTime as relative time with the given locale
  String formatRelative(Locale locale) {
    return LocalizationService.formatRelativeTime(this, locale);
  }
}

/// Extension on double to provide localized formatting
extension NumberLocalization on double {
  /// Format this number with the given locale
  String format(Locale locale) {
    return LocalizationService.formatNumber(this, locale);
  }

  /// Format this number as currency with the given locale
  String formatCurrency(String currencyCode, Locale locale) {
    return LocalizationService.formatCurrency(this, currencyCode, locale);
  }

  /// Format this number as percentage with the given locale
  String formatPercentage(Locale locale) {
    return LocalizationService.formatPercentage(this, locale);
  }
}

/// Extension on int to provide localized formatting
extension IntLocalization on int {
  /// Format this integer with the given locale
  String format(Locale locale) {
    return LocalizationService.formatNumber(toDouble(), locale);
  }

  /// Format this integer as currency with the given locale
  String formatCurrency(String currencyCode, Locale locale) {
    return LocalizationService.formatCurrency(toDouble(), currencyCode, locale);
  }
}

/// Extension on String to provide localized parsing
extension StringLocalization on String {
  /// Parse this string as a date with the given locale
  DateTime? parseDate(Locale locale) {
    return LocalizationService.parseDate(this, locale);
  }

  /// Parse this string as a number with the given locale
  double? parseNumber(Locale locale) {
    return LocalizationService.parseNumber(this, locale);
  }
}
