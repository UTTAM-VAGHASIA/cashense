import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Collection of input formatters for various use cases
class AppInputFormatters {
  AppInputFormatters._();

  /// Phone number formatter (removes non-digits and formats)
  static TextInputFormatter phoneNumber = FilteringTextInputFormatter.allow(
    RegExp(r'[0-9+\-\s\(\)]'),
  );

  /// Only digits formatter
  static TextInputFormatter digitsOnly = FilteringTextInputFormatter.digitsOnly;

  /// Only letters formatter
  static TextInputFormatter lettersOnly = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z\s]'),
  );

  /// Alphanumeric formatter
  static TextInputFormatter alphanumeric = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9]'),
  );

  /// Email formatter (basic)
  static TextInputFormatter email = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9@._-]'),
  );

  /// Decimal number formatter (allows one decimal point)
  static TextInputFormatter decimal = FilteringTextInputFormatter.allow(
    RegExp(r'^\d*\.?\d*'),
  );

  /// Currency formatter
  static CurrencyInputFormatter currency({
    String symbol = '\$',
    int decimalPlaces = 2,
    String locale = 'en_US',
  }) {
    return CurrencyInputFormatter(
      symbol: symbol,
      decimalPlaces: decimalPlaces,
      locale: locale,
    );
  }

  /// Credit card number formatter
  static CreditCardInputFormatter creditCard = CreditCardInputFormatter();

  /// Expiry date formatter (MM/YY)
  static ExpiryDateInputFormatter expiryDate = ExpiryDateInputFormatter();

  /// CVV formatter
  static TextInputFormatter cvv = LengthLimitingTextInputFormatter(4);

  /// Uppercase formatter
  static UpperCaseTextFormatter uppercase = UpperCaseTextFormatter();

  /// Lowercase formatter
  static LowerCaseTextFormatter lowercase = LowerCaseTextFormatter();

  /// Capitalize first letter formatter
  static CapitalizeTextFormatter capitalize = CapitalizeTextFormatter();

  /// No spaces formatter
  static TextInputFormatter noSpaces = FilteringTextInputFormatter.deny(
    RegExp(r'\s'),
  );

  /// Username formatter (alphanumeric + underscore, no spaces)
  static TextInputFormatter username = FilteringTextInputFormatter.allow(
    RegExp(r'[a-zA-Z0-9_]'),
  );

  /// Password formatter (printable ASCII characters)
  static TextInputFormatter password = FilteringTextInputFormatter.allow(
    RegExp(r'[!-~]'),
  );
}

/// Currency input formatter
class CurrencyInputFormatter extends TextInputFormatter {
  final String symbol;
  final int decimalPlaces;
  final NumberFormat _formatter;

  CurrencyInputFormatter({
    required this.symbol,
    required this.decimalPlaces,
    required String locale,
  }) : _formatter = NumberFormat.currency(
         symbol: symbol,
         decimalDigits: decimalPlaces,
         locale: locale,
       );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    // Convert to double and format
    final value = double.parse(digitsOnly) / 100;
    final formatted = _formatter.format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Credit card input formatter
class CreditCardInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Expiry date input formatter (MM/YY)
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (text.length >= 2) {
      final month = text.substring(0, 2);
      final year = text.length > 2
          ? text.substring(2, text.length > 4 ? 4 : text.length)
          : '';
      final formatted = year.isEmpty ? month : '$month/$year';

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Uppercase text formatter
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Lowercase text formatter
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

/// Capitalize first letter formatter
class CapitalizeTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final words = newValue.text.split(' ');
    final capitalizedWords = words
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');

    return TextEditingValue(
      text: capitalizedWords,
      selection: newValue.selection,
    );
  }
}
