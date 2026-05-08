import 'package:intl/intl.dart';

/// INR-first currency formatting used across dashboards.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _inrCompact = NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 1,
  );

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// `₹1,23,456` — preferred for cards and lists where space allows.
  static String format(double amount) => _inr.format(amount);

  /// `₹1,23,456.78` — use only when paise precision matters.
  static String formatExact(double amount) => _inrWithDecimals.format(amount);

  /// `₹1.2L` / `₹1.5Cr` — use when horizontal space is tight.
  static String compact(double amount) => _inrCompact.format(amount);
}
