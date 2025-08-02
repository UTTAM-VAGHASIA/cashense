import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Enhanced utility extensions for better code reusability and readability
///
/// **Improvements:**
/// - Context extensions for common operations
/// - AsyncValue extensions for better error handling
/// - DateTime extensions for financial apps
/// - String extensions for validation
/// - Number extensions for currency formatting

/// Context extensions for common UI operations
extension BuildContextExtensions on BuildContext {
  /// Get theme data safely
  ThemeData get theme => Theme.of(this);

  /// Get color scheme safely
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme safely
  TextTheme get textTheme => theme.textTheme;

  /// Get media query data safely
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if device is in dark mode
  bool get isDarkMode => mediaQuery.platformBrightness == Brightness.dark;

  /// Check if device is in landscape mode
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if device is a tablet (width > 600)
  bool get isTablet => screenWidth > 600;

  /// Check if device is a phone
  bool get isPhone => !isTablet;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => mediaQuery.padding;

  /// Show snackbar with enhanced styling
  void showSnackBar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? Colors.white),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? colorScheme.primary,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.error,
      icon: Icons.error_outline,
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle_outline,
    );
  }

  /// Show warning snackbar
  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
      icon: Icons.warning_outlined,
    );
  }
}

/// AsyncValue extensions for better error handling and UI states
extension AsyncValueExtensions<T> on AsyncValue<T> {
  /// Check if has data and is not loading
  bool get hasDataAndNotLoading => hasValue && !isLoading;

  /// Get data or null safely
  T? get dataOrNull => hasValue ? value : null;

  /// Map data with loading and error handling
  Widget mapToWidget({
    required Widget Function(T data) data,
    Widget Function()? loading,
    Widget Function(Object error, StackTrace stackTrace)? error,
  }) {
    return when(
      data: data,
      loading:
          loading ?? () => const Center(child: CircularProgressIndicator()),
      error:
          error ??
          (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${err.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
    );
  }

  /// Handle async value with callbacks
  void handle({
    void Function(T data)? onData,
    void Function()? onLoading,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    when(
      data: (data) => onData?.call(data),
      loading: () => onLoading?.call(),
      error: (error, stackTrace) => onError?.call(error, stackTrace),
    );
  }
}

/// DateTime extensions for financial applications
extension DateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is this week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is this month
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if date is this year
  bool get isThisYear {
    final now = DateTime.now();
    return year == now.year;
  }

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get relative description (Today, Yesterday, etc.)
  String get relativeDescription {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    if (isThisWeek) return 'This week';
    if (isThisMonth) return 'This month';
    if (isThisYear) return 'This year';
    return 'Older';
  }

  /// Format for financial transactions
  String formatForTransaction() {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';

    final now = DateTime.now();
    final difference = now.difference(this).inDays;

    if (difference < 7) {
      return '$difference days ago';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }
}

/// String extensions for validation and formatting
extension StringExtensions on String {
  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Check if string is a valid phone number (basic)
  bool get isValidPhoneNumber {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(this);
  }

  /// Check if string is a valid currency amount
  bool get isValidCurrencyAmount {
    return RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(this);
  }

  /// Capitalize first letter
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalize each word
  String get titleCase {
    return split(' ').map((word) => word.capitalized).join(' ');
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Check if string contains only digits
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);

  /// Check if string is empty or only whitespace
  bool get isBlank => trim().isEmpty;

  /// Check if string is not empty and not only whitespace
  bool get isNotBlank => !isBlank;

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Parse to double safely
  double? get toDoubleOrNull {
    try {
      return double.parse(this);
    } catch (e) {
      return null;
    }
  }

  /// Parse to int safely
  int? get toIntOrNull {
    try {
      return int.parse(this);
    } catch (e) {
      return null;
    }
  }
}

/// Number extensions for currency and financial formatting
extension DoubleExtensions on double {
  /// Format as currency with symbol
  String formatAsCurrency({
    String symbol = '\$',
    int decimalPlaces = 2,
    bool showSymbol = true,
  }) {
    final formatted = toStringAsFixed(decimalPlaces);
    return showSymbol ? '$symbol$formatted' : formatted;
  }

  /// Format as percentage
  String formatAsPercentage({int decimalPlaces = 1}) {
    return '${(this * 100).toStringAsFixed(decimalPlaces)}%';
  }

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Get absolute value
  double get abs => this < 0 ? -this : this;

  /// Round to specific decimal places
  double roundToDecimalPlaces(int decimalPlaces) {
    final factor = pow(10, decimalPlaces).toDouble();
    return (this * factor).round() / factor;
  }
}

/// Int extensions for financial calculations
extension IntExtensions on int {
  /// Format as currency (assuming cents)
  String formatAsCurrency({String symbol = '\$', bool showSymbol = true}) {
    final dollars = this / 100;
    return dollars.formatAsCurrency(symbol: symbol, showSymbol: showSymbol);
  }

  /// Check if number is positive
  bool get isPositive => this > 0;

  /// Check if number is negative
  bool get isNegative => this < 0;

  /// Check if number is zero
  bool get isZero => this == 0;

  /// Get absolute value
  int get abs => this < 0 ? -this : this;
}

/// List extensions for better collection handling
extension ListExtensions<T> on List<T> {
  /// Get element at index safely
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// Check if list is not empty
  bool get isNotEmpty => !isEmpty;

  /// Get first element safely
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element safely
  T? get lastOrNull => isEmpty ? null : last;

  /// Add element if condition is true
  void addIf(bool condition, T element) {
    if (condition) add(element);
  }

  /// Add all elements if condition is true
  void addAllIf(bool condition, Iterable<T> elements) {
    if (condition) addAll(elements);
  }
}
