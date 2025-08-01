import 'package:flutter/material.dart';

/// Comprehensive theme configuration for the Cashense app
@immutable
class ThemeConfig {
  const ThemeConfig({
    this.themeMode = ThemeMode.system,
    this.useDynamicColors = false,
    this.useHighContrast = false,
    this.fontScale = 1.0,
    this.colorVariant = ColorVariant.defaultVariant,
    this.customSeedColor,
    this.reducedMotion = false,
    this.useMonochromeIcons = false,
    this.borderRadiusStyle = BorderRadiusStyle.rounded,
    this.elevationStyle = ElevationStyle.material3,
    this.typographyStyle = TypographyStyle.material3,
  });

  final ThemeMode themeMode;
  final bool useDynamicColors;
  final bool useHighContrast;
  final double fontScale;
  final ColorVariant colorVariant;
  final Color? customSeedColor;
  final bool reducedMotion;
  final bool useMonochromeIcons;
  final BorderRadiusStyle borderRadiusStyle;
  final ElevationStyle elevationStyle;
  final TypographyStyle typographyStyle;

  /// Create a copy with updated values
  ThemeConfig copyWith({
    ThemeMode? themeMode,
    bool? useDynamicColors,
    bool? useHighContrast,
    double? fontScale,
    ColorVariant? colorVariant,
    Color? customSeedColor,
    bool? reducedMotion,
    bool? useMonochromeIcons,
    BorderRadiusStyle? borderRadiusStyle,
    ElevationStyle? elevationStyle,
    TypographyStyle? typographyStyle,
  }) {
    return ThemeConfig(
      themeMode: themeMode ?? this.themeMode,
      useDynamicColors: useDynamicColors ?? this.useDynamicColors,
      useHighContrast: useHighContrast ?? this.useHighContrast,
      fontScale: fontScale ?? this.fontScale,
      colorVariant: colorVariant ?? this.colorVariant,
      customSeedColor: customSeedColor ?? this.customSeedColor,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      useMonochromeIcons: useMonochromeIcons ?? this.useMonochromeIcons,
      borderRadiusStyle: borderRadiusStyle ?? this.borderRadiusStyle,
      elevationStyle: elevationStyle ?? this.elevationStyle,
      typographyStyle: typographyStyle ?? this.typographyStyle,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'useDynamicColors': useDynamicColors,
      'useHighContrast': useHighContrast,
      'fontScale': fontScale,
      'colorVariant': colorVariant.name,
      'customSeedColor': customSeedColor?.toARGB32(),
      'reducedMotion': reducedMotion,
      'useMonochromeIcons': useMonochromeIcons,
      'borderRadiusStyle': borderRadiusStyle.name,
      'elevationStyle': elevationStyle.name,
      'typographyStyle': typographyStyle.name,
    };
  }

  /// Create from JSON
  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      themeMode: ThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => ThemeMode.system,
      ),
      useDynamicColors: json['useDynamicColors'] as bool? ?? false,
      useHighContrast: json['useHighContrast'] as bool? ?? false,
      fontScale: (json['fontScale'] as num?)?.toDouble() ?? 1.0,
      colorVariant: ColorVariant.values.firstWhere(
        (e) => e.name == json['colorVariant'],
        orElse: () => ColorVariant.defaultVariant,
      ),
      customSeedColor: json['customSeedColor'] != null
          ? Color(json['customSeedColor'] as int)
          : null,
      reducedMotion: json['reducedMotion'] as bool? ?? false,
      useMonochromeIcons: json['useMonochromeIcons'] as bool? ?? false,
      borderRadiusStyle: BorderRadiusStyle.values.firstWhere(
        (e) => e.name == json['borderRadiusStyle'],
        orElse: () => BorderRadiusStyle.rounded,
      ),
      elevationStyle: ElevationStyle.values.firstWhere(
        (e) => e.name == json['elevationStyle'],
        orElse: () => ElevationStyle.material3,
      ),
      typographyStyle: TypographyStyle.values.firstWhere(
        (e) => e.name == json['typographyStyle'],
        orElse: () => TypographyStyle.material3,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeConfig &&
        other.themeMode == themeMode &&
        other.useDynamicColors == useDynamicColors &&
        other.useHighContrast == useHighContrast &&
        other.fontScale == fontScale &&
        other.colorVariant == colorVariant &&
        other.customSeedColor == customSeedColor &&
        other.reducedMotion == reducedMotion &&
        other.useMonochromeIcons == useMonochromeIcons &&
        other.borderRadiusStyle == borderRadiusStyle &&
        other.elevationStyle == elevationStyle &&
        other.typographyStyle == typographyStyle;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      useDynamicColors,
      useHighContrast,
      fontScale,
      colorVariant,
      customSeedColor,
      reducedMotion,
      useMonochromeIcons,
      borderRadiusStyle,
      elevationStyle,
      typographyStyle,
    );
  }
}

/// Color variant options
enum ColorVariant { defaultVariant, vibrant, monochrome, highContrast, custom }

/// Border radius style options
enum BorderRadiusStyle { sharp, rounded, extraRounded }

/// Elevation style options
enum ElevationStyle { flat, material2, material3, elevated }

/// Typography style options
enum TypographyStyle { compact, material3, comfortable, large }

/// Theme configuration extensions
extension ThemeConfigExtensions on ThemeConfig {
  /// Get border radius values based on style
  BorderRadiusConfig get borderRadiusConfig {
    switch (borderRadiusStyle) {
      case BorderRadiusStyle.sharp:
        return const BorderRadiusConfig(
          small: 0,
          medium: 0,
          large: 0,
          extraLarge: 0,
        );
      case BorderRadiusStyle.rounded:
        return const BorderRadiusConfig(
          small: 8,
          medium: 12,
          large: 16,
          extraLarge: 20,
        );
      case BorderRadiusStyle.extraRounded:
        return const BorderRadiusConfig(
          small: 12,
          medium: 16,
          large: 24,
          extraLarge: 32,
        );
    }
  }

  /// Get elevation values based on style
  ElevationConfig get elevationConfig {
    switch (elevationStyle) {
      case ElevationStyle.flat:
        return const ElevationConfig(
          level0: 0,
          level1: 0,
          level2: 0,
          level3: 0,
          level4: 0,
          level5: 0,
        );
      case ElevationStyle.material2:
        return const ElevationConfig(
          level0: 0,
          level1: 1,
          level2: 2,
          level3: 4,
          level4: 8,
          level5: 16,
        );
      case ElevationStyle.material3:
        return const ElevationConfig(
          level0: 0,
          level1: 1,
          level2: 3,
          level3: 6,
          level4: 8,
          level5: 12,
        );
      case ElevationStyle.elevated:
        return const ElevationConfig(
          level0: 0,
          level1: 2,
          level2: 4,
          level3: 8,
          level4: 12,
          level5: 20,
        );
    }
  }

  /// Get typography scale based on style
  TypographyConfig get typographyConfig {
    switch (typographyStyle) {
      case TypographyStyle.compact:
        return TypographyConfig(
          displayLarge: 48 * fontScale,
          displayMedium: 40 * fontScale,
          displaySmall: 32 * fontScale,
          headlineLarge: 28 * fontScale,
          headlineMedium: 24 * fontScale,
          headlineSmall: 20 * fontScale,
          titleLarge: 18 * fontScale,
          titleMedium: 14 * fontScale,
          titleSmall: 12 * fontScale,
          bodyLarge: 14 * fontScale,
          bodyMedium: 12 * fontScale,
          bodySmall: 10 * fontScale,
          labelLarge: 12 * fontScale,
          labelMedium: 10 * fontScale,
          labelSmall: 9 * fontScale,
        );
      case TypographyStyle.material3:
        return TypographyConfig(
          displayLarge: 57 * fontScale,
          displayMedium: 45 * fontScale,
          displaySmall: 36 * fontScale,
          headlineLarge: 32 * fontScale,
          headlineMedium: 28 * fontScale,
          headlineSmall: 24 * fontScale,
          titleLarge: 22 * fontScale,
          titleMedium: 16 * fontScale,
          titleSmall: 14 * fontScale,
          bodyLarge: 16 * fontScale,
          bodyMedium: 14 * fontScale,
          bodySmall: 12 * fontScale,
          labelLarge: 14 * fontScale,
          labelMedium: 12 * fontScale,
          labelSmall: 11 * fontScale,
        );
      case TypographyStyle.comfortable:
        return TypographyConfig(
          displayLarge: 64 * fontScale,
          displayMedium: 52 * fontScale,
          displaySmall: 40 * fontScale,
          headlineLarge: 36 * fontScale,
          headlineMedium: 32 * fontScale,
          headlineSmall: 28 * fontScale,
          titleLarge: 24 * fontScale,
          titleMedium: 18 * fontScale,
          titleSmall: 16 * fontScale,
          bodyLarge: 18 * fontScale,
          bodyMedium: 16 * fontScale,
          bodySmall: 14 * fontScale,
          labelLarge: 16 * fontScale,
          labelMedium: 14 * fontScale,
          labelSmall: 12 * fontScale,
        );
      case TypographyStyle.large:
        return TypographyConfig(
          displayLarge: 72 * fontScale,
          displayMedium: 60 * fontScale,
          displaySmall: 48 * fontScale,
          headlineLarge: 40 * fontScale,
          headlineMedium: 36 * fontScale,
          headlineSmall: 32 * fontScale,
          titleLarge: 28 * fontScale,
          titleMedium: 20 * fontScale,
          titleSmall: 18 * fontScale,
          bodyLarge: 20 * fontScale,
          bodyMedium: 18 * fontScale,
          bodySmall: 16 * fontScale,
          labelLarge: 18 * fontScale,
          labelMedium: 16 * fontScale,
          labelSmall: 14 * fontScale,
        );
    }
  }

  /// Check if theme is dark
  bool isDark(BuildContext context) {
    switch (themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
  }

  /// Get effective brightness
  Brightness getBrightness(BuildContext context) {
    return isDark(context) ? Brightness.dark : Brightness.light;
  }
}

/// Border radius configuration
@immutable
class BorderRadiusConfig {
  const BorderRadiusConfig({
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,
  });

  final double small;
  final double medium;
  final double large;
  final double extraLarge;

  /// Get border radius for buttons
  double get button => medium;

  /// Get border radius for cards
  double get card => large;

  /// Get border radius for dialogs
  double get dialog => extraLarge;

  /// Get border radius for chips
  double get chip => extraLarge;

  /// Get border radius for text fields
  double get textField => medium;
}

/// Elevation configuration
@immutable
class ElevationConfig {
  const ElevationConfig({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  final double level0;
  final double level1;
  final double level2;
  final double level3;
  final double level4;
  final double level5;

  /// Get elevation for cards
  double get card => level1;

  /// Get elevation for app bar
  double get appBar => level0;

  /// Get elevation for FAB
  double get fab => level3;

  /// Get elevation for dialogs
  double get dialog => level4;

  /// Get elevation for bottom sheet
  double get bottomSheet => level2;

  /// Get elevation for navigation bar
  double get navigationBar => level2;
}

/// Typography configuration
@immutable
class TypographyConfig {
  const TypographyConfig({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  final double displayLarge;
  final double displayMedium;
  final double displaySmall;
  final double headlineLarge;
  final double headlineMedium;
  final double headlineSmall;
  final double titleLarge;
  final double titleMedium;
  final double titleSmall;
  final double bodyLarge;
  final double bodyMedium;
  final double bodySmall;
  final double labelLarge;
  final double labelMedium;
  final double labelSmall;
}

/// Animation configuration
@immutable
class AnimationConfig {
  const AnimationConfig({
    this.enableAnimations = true,
    this.shortDuration = const Duration(milliseconds: 150),
    this.mediumDuration = const Duration(milliseconds: 300),
    this.longDuration = const Duration(milliseconds: 500),
    this.pageTransitionDuration = const Duration(milliseconds: 300),
  });

  final bool enableAnimations;
  final Duration shortDuration;
  final Duration mediumDuration;
  final Duration longDuration;
  final Duration pageTransitionDuration;

  /// Get duration based on reduced motion preference
  Duration getDuration(Duration baseDuration, bool reducedMotion) {
    if (!enableAnimations || reducedMotion) {
      return Duration.zero;
    }
    return baseDuration;
  }
}

/// Spacing configuration
@immutable
class SpacingConfig {
  const SpacingConfig({
    this.xs = 4.0,
    this.sm = 8.0,
    this.md = 16.0,
    this.lg = 24.0,
    this.xl = 32.0,
    this.xxl = 48.0,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  /// Get padding for different components
  EdgeInsets get cardPadding => EdgeInsets.all(md);
  EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: lg, vertical: sm);
  EdgeInsets get listTilePadding =>
      EdgeInsets.symmetric(horizontal: md, vertical: sm);
  EdgeInsets get dialogPadding => EdgeInsets.all(lg);
  EdgeInsets get screenPadding => EdgeInsets.all(md);
}
