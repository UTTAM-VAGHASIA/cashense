import 'package:flutter/material.dart';

/// Enhanced custom colors for financial applications
@immutable
class FinancialColors extends ThemeExtension<FinancialColors> {
  const FinancialColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.income,
    required this.expense,
    required this.investment,
    required this.savings,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color income;
  final Color expense;
  final Color investment;
  final Color savings;

  @override
  FinancialColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? income,
    Color? expense,
    Color? investment,
    Color? savings,
  }) {
    return FinancialColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      investment: investment ?? this.investment,
      savings: savings ?? this.savings,
    );
  }

  @override
  FinancialColors lerp(FinancialColors? other, double t) {
    if (other is! FinancialColors) {
      return this;
    }
    return FinancialColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      investment: Color.lerp(investment, other.investment, t)!,
      savings: Color.lerp(savings, other.savings, t)!,
    );
  }
}

/// Extension to access financial colors from theme
extension FinancialColorsExtension on ThemeData {
  FinancialColors get financialColors =>
      extension<FinancialColors>() ??
      const FinancialColors(
        success: Color(0xFF2E7D32),
        warning: Color(0xFFEF6C00),
        info: Color(0xFF0288D1),
        income: Color(0xFF388E3C),
        expense: Color(0xFFD32F2F),
        investment: Color(0xFF7B1FA2),
        savings: Color(0xFF1976D2),
      );
}

/// Utility class for theme-related constants and helpers
class ThemeConstants {
  ThemeConstants._(); // Private constructor

  // Border radius constants
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double fabBorderRadius = 16.0;
  static const double dialogBorderRadius = 20.0;
  static const double chipBorderRadius = 20.0;

  // Padding constants
  static const EdgeInsets cardMargin = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );
  static const EdgeInsets listTilePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  // Elevation constants
  static const double cardElevation = 2.0;
  static const double cardElevationDark = 4.0;
  static const double fabElevation = 6.0;
  static const double fabElevationDark = 8.0;
  static const double dialogElevation = 6.0;
  static const double dialogElevationDark = 8.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}

/// Helper class for creating consistent shadow colors
class ShadowHelper {
  ShadowHelper._();

  static Color light(Color shadowColor) => shadowColor.withValues(alpha: 0.1);
  static Color dark(Color shadowColor) => shadowColor.withValues(alpha: 0.3);

  static Color forBrightness(Color shadowColor, Brightness brightness) {
    return brightness == Brightness.light
        ? light(shadowColor)
        : dark(shadowColor);
  }
}
