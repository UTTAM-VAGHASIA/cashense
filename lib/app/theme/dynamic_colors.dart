import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

/// Dynamic color generation and management for Material 3 theming
class DynamicColors {
  DynamicColors._();

  /// Financial app brand colors with semantic meaning
  static const Color primarySeedColor = Color(
    0xFF1B5E20,
  ); // Deep green for growth
  static const Color secondarySeedColor = Color(
    0xFF0D47A1,
  ); // Blue for trust/stability
  static const Color tertiarySeedColor = Color(
    0xFF4A148C,
  ); // Purple for premium
  static const Color errorSeedColor = Color(0xFFB71C1C); // Deep red for errors

  /// Financial semantic colors
  static const Color successColor = Color(0xFF2E7D32); // Success green
  static const Color warningColor = Color(0xFFEF6C00); // Warning orange
  static const Color infoColor = Color(0xFF0288D1); // Info blue
  static const Color incomeColor = Color(0xFF388E3C); // Income green
  static const Color expenseColor = Color(0xFFD32F2F); // Expense red
  static const Color investmentColor = Color(0xFF7B1FA2); // Investment purple
  static const Color savingsColor = Color(0xFF1976D2); // Savings blue

  /// Generate light color scheme with dynamic colors support
  static ColorScheme generateLightColorScheme({
    ColorScheme? dynamicColorScheme,
    Color? seedColor,
  }) {
    final effectiveSeedColor = seedColor ?? primarySeedColor;

    // Use dynamic colors if available, otherwise generate from seed
    if (dynamicColorScheme != null) {
      return dynamicColorScheme.copyWith(
        // Override specific colors for financial app consistency
        secondary: _harmonizeColor(
          secondarySeedColor,
          dynamicColorScheme.primary,
        ),
        tertiary: _harmonizeColor(
          tertiarySeedColor,
          dynamicColorScheme.primary,
        ),
        error: _harmonizeColor(errorSeedColor, dynamicColorScheme.primary),
      );
    }

    return ColorScheme.fromSeed(
      seedColor: effectiveSeedColor,
      brightness: Brightness.light,
      secondary: secondarySeedColor,
      tertiary: tertiarySeedColor,
      error: errorSeedColor,
    );
  }

  /// Generate dark color scheme with dynamic colors support
  static ColorScheme generateDarkColorScheme({
    ColorScheme? dynamicColorScheme,
    Color? seedColor,
  }) {
    final effectiveSeedColor = seedColor ?? primarySeedColor;

    // Use dynamic colors if available, otherwise generate from seed
    if (dynamicColorScheme != null) {
      return dynamicColorScheme.copyWith(
        // Override specific colors for financial app consistency
        secondary: _harmonizeColor(
          secondarySeedColor,
          dynamicColorScheme.primary,
        ),
        tertiary: _harmonizeColor(
          tertiarySeedColor,
          dynamicColorScheme.primary,
        ),
        error: _harmonizeColor(errorSeedColor, dynamicColorScheme.primary),
      );
    }

    return ColorScheme.fromSeed(
      seedColor: effectiveSeedColor,
      brightness: Brightness.dark,
      secondary: secondarySeedColor,
      tertiary: tertiarySeedColor,
      error: errorSeedColor,
    );
  }

  /// Generate financial colors extension based on color scheme
  static FinancialColors generateFinancialColors(ColorScheme colorScheme) {
    return FinancialColors(
      success: _harmonizeColor(successColor, colorScheme.primary),
      warning: _harmonizeColor(warningColor, colorScheme.primary),
      info: _harmonizeColor(infoColor, colorScheme.primary),
      income: _harmonizeColor(incomeColor, colorScheme.primary),
      expense: _harmonizeColor(expenseColor, colorScheme.primary),
      investment: _harmonizeColor(investmentColor, colorScheme.primary),
      savings: _harmonizeColor(savingsColor, colorScheme.primary),
    );
  }

  /// Harmonize a color with the primary color for better visual cohesion
  static Color _harmonizeColor(Color color, Color primary) {
    try {
      return color.harmonizeWith(primary);
    } catch (e) {
      // Fallback if harmonization fails
      return color;
    }
  }

  /// Generate custom color scheme from user-selected color
  static ColorScheme generateCustomColorScheme({
    required Color seedColor,
    required Brightness brightness,
  }) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      secondary: _harmonizeColor(secondarySeedColor, seedColor),
      tertiary: _harmonizeColor(tertiarySeedColor, seedColor),
      error: _harmonizeColor(errorSeedColor, seedColor),
    );
  }

  /// Get color scheme variants for different contexts
  static Map<String, ColorScheme> getColorSchemeVariants(
    ColorScheme baseScheme,
  ) {
    return {
      'default': baseScheme,
      'high_contrast': _generateHighContrastScheme(baseScheme),
      'monochrome': _generateMonochromeScheme(baseScheme),
      'vibrant': _generateVibrantScheme(baseScheme),
    };
  }

  /// Generate high contrast variant
  static ColorScheme _generateHighContrastScheme(ColorScheme baseScheme) {
    return baseScheme.copyWith(
      primary: _adjustColorContrast(baseScheme.primary, 1.5),
      secondary: _adjustColorContrast(baseScheme.secondary, 1.3),
      tertiary: _adjustColorContrast(baseScheme.tertiary, 1.3),
      error: _adjustColorContrast(baseScheme.error, 1.4),
    );
  }

  /// Generate monochrome variant
  static ColorScheme _generateMonochromeScheme(ColorScheme baseScheme) {
    final luminance = baseScheme.primary.computeLuminance();
    final monoColor = Color.fromRGBO(
      (luminance * 255).round(),
      (luminance * 255).round(),
      (luminance * 255).round(),
      1.0,
    );

    return ColorScheme.fromSeed(
      seedColor: monoColor,
      brightness: baseScheme.brightness,
    );
  }

  /// Generate vibrant variant
  static ColorScheme _generateVibrantScheme(ColorScheme baseScheme) {
    return baseScheme.copyWith(
      primary: _adjustColorSaturation(baseScheme.primary, 1.3),
      secondary: _adjustColorSaturation(baseScheme.secondary, 1.2),
      tertiary: _adjustColorSaturation(baseScheme.tertiary, 1.2),
    );
  }

  /// Adjust color contrast
  static Color _adjustColorContrast(Color color, double factor) {
    final hsl = HSLColor.fromColor(color);
    final adjustedLightness = (hsl.lightness * factor).clamp(0.0, 1.0);
    return hsl.withLightness(adjustedLightness).toColor();
  }

  /// Adjust color saturation
  static Color _adjustColorSaturation(Color color, double factor) {
    final hsl = HSLColor.fromColor(color);
    final adjustedSaturation = (hsl.saturation * factor).clamp(0.0, 1.0);
    return hsl.withSaturation(adjustedSaturation).toColor();
  }

  /// Generate accessible color pairs
  static Map<String, Color> generateAccessibleColorPairs(
    ColorScheme colorScheme,
  ) {
    return {
      'primary_on_surface': _ensureAccessibleContrast(
        colorScheme.primary,
        colorScheme.surface,
      ),
      'secondary_on_surface': _ensureAccessibleContrast(
        colorScheme.secondary,
        colorScheme.surface,
      ),
      'error_on_surface': _ensureAccessibleContrast(
        colorScheme.error,
        colorScheme.surface,
      ),
    };
  }

  /// Ensure accessible contrast between two colors
  static Color _ensureAccessibleContrast(Color foreground, Color background) {
    const minContrastRatio = 4.5; // WCAG AA standard

    double contrastRatio = _calculateContrastRatio(foreground, background);

    if (contrastRatio >= minContrastRatio) {
      return foreground;
    }

    // Adjust lightness to meet contrast requirements
    final hsl = HSLColor.fromColor(foreground);
    final backgroundLuminance = background.computeLuminance();

    double adjustedLightness = hsl.lightness;

    // Make darker if background is light, lighter if background is dark
    if (backgroundLuminance > 0.5) {
      // Light background - make foreground darker
      while (contrastRatio < minContrastRatio && adjustedLightness > 0.0) {
        adjustedLightness -= 0.05;
        final adjustedColor = hsl.withLightness(adjustedLightness).toColor();
        contrastRatio = _calculateContrastRatio(adjustedColor, background);
      }
    } else {
      // Dark background - make foreground lighter
      while (contrastRatio < minContrastRatio && adjustedLightness < 1.0) {
        adjustedLightness += 0.05;
        final adjustedColor = hsl.withLightness(adjustedLightness).toColor();
        contrastRatio = _calculateContrastRatio(adjustedColor, background);
      }
    }

    return hsl.withLightness(adjustedLightness.clamp(0.0, 1.0)).toColor();
  }

  /// Calculate contrast ratio between two colors
  static double _calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Generate color palette for data visualization
  static List<Color> generateDataVisualizationPalette(
    ColorScheme colorScheme, {
    int count = 8,
  }) {
    final baseColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      incomeColor,
      expenseColor,
      investmentColor,
      savingsColor,
      warningColor,
    ];

    if (count <= baseColors.length) {
      return baseColors.take(count).toList();
    }

    // Generate additional colors by varying hue
    final additionalColors = <Color>[];
    final hueStep = 360 / count;

    for (int i = baseColors.length; i < count; i++) {
      final hue = (i * hueStep) % 360;
      final color = HSLColor.fromAHSL(
        1.0,
        hue,
        0.7, // Saturation
        colorScheme.brightness == Brightness.light ? 0.5 : 0.7, // Lightness
      ).toColor();

      additionalColors.add(_harmonizeColor(color, colorScheme.primary));
    }

    return [...baseColors, ...additionalColors];
  }
}

/// Enhanced financial colors extension
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

  /// Get color by transaction type
  Color getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return income;
      case TransactionType.expense:
        return expense;
      case TransactionType.investment:
        return investment;
      case TransactionType.savings:
        return savings;
    }
  }

  /// Get color by status
  Color getStatusColor(StatusType status) {
    switch (status) {
      case StatusType.success:
        return success;
      case StatusType.warning:
        return warning;
      case StatusType.error:
        return expense; // Reuse expense color for errors
      case StatusType.info:
        return info;
    }
  }
}

/// Transaction type enumeration
enum TransactionType { income, expense, investment, savings }

/// Status type enumeration
enum StatusType { success, warning, error, info }
