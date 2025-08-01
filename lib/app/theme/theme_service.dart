import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'theme_config.dart';
import 'dynamic_colors.dart';
import '../../viewmodels/features/settings/settings_viewmodel.dart'
    show sharedPreferencesProvider;

/// Service for managing theme preferences and configurations
class ThemeService {
  ThemeService(this._prefs);

  final SharedPreferences _prefs;
  static const String _themeConfigKey = 'theme_config';
  static const String _customColorsKey = 'custom_colors';

  /// Load theme configuration from storage
  ThemeConfig loadThemeConfig() {
    try {
      final configJson = _prefs.getString(_themeConfigKey);
      if (configJson != null) {
        final configMap = jsonDecode(configJson) as Map<String, dynamic>;
        return ThemeConfig.fromJson(configMap);
      }
    } catch (e) {
      developer.log(
        'Error loading theme config: $e',
        name: 'ThemeService',
        error: e,
      );
    }

    return const ThemeConfig(); // Return default config
  }

  /// Save theme configuration to storage
  Future<void> saveThemeConfig(ThemeConfig config) async {
    try {
      final configJson = jsonEncode(config.toJson());
      await _prefs.setString(_themeConfigKey, configJson);
      developer.log('Theme config saved', name: 'ThemeService');
    } catch (e) {
      developer.log(
        'Error saving theme config: $e',
        name: 'ThemeService',
        error: e,
      );
    }
  }

  /// Load custom colors from storage
  Map<String, Color> loadCustomColors() {
    try {
      final colorsJson = _prefs.getString(_customColorsKey);
      if (colorsJson != null) {
        final colorsMap = jsonDecode(colorsJson) as Map<String, dynamic>;
        return colorsMap.map(
          (key, value) => MapEntry(key, Color(value as int)),
        );
      }
    } catch (e) {
      developer.log(
        'Error loading custom colors: $e',
        name: 'ThemeService',
        error: e,
      );
    }

    return {};
  }

  /// Save custom colors to storage
  Future<void> saveCustomColors(Map<String, Color> colors) async {
    try {
      final colorsMap = colors.map(
        (key, value) => MapEntry(key, value.toARGB32()),
      );
      final colorsJson = jsonEncode(colorsMap);
      await _prefs.setString(_customColorsKey, colorsJson);
      developer.log('Custom colors saved', name: 'ThemeService');
    } catch (e) {
      developer.log(
        'Error saving custom colors: $e',
        name: 'ThemeService',
        error: e,
      );
    }
  }

  /// Clear all theme preferences
  Future<void> clearThemePreferences() async {
    try {
      await _prefs.remove(_themeConfigKey);
      await _prefs.remove(_customColorsKey);
      developer.log('Theme preferences cleared', name: 'ThemeService');
    } catch (e) {
      developer.log(
        'Error clearing theme preferences: $e',
        name: 'ThemeService',
        error: e,
      );
    }
  }
}

/// Theme state notifier for managing theme configuration
class ThemeNotifier extends StateNotifier<ThemeConfig> {
  ThemeNotifier(this._themeService) : super(const ThemeConfig()) {
    _loadThemeConfig();
  }

  final ThemeService _themeService;

  /// Load theme configuration
  void _loadThemeConfig() {
    state = _themeService.loadThemeConfig();
  }

  /// Update theme mode
  Future<void> updateThemeMode(ThemeMode themeMode) async {
    final newConfig = state.copyWith(themeMode: themeMode);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Toggle theme mode
  Future<void> toggleThemeMode() async {
    final newMode = switch (state.themeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
      ThemeMode.system => ThemeMode.light,
    };
    await updateThemeMode(newMode);
  }

  /// Update dynamic colors preference
  Future<void> updateUseDynamicColors(bool useDynamicColors) async {
    final newConfig = state.copyWith(useDynamicColors: useDynamicColors);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update high contrast preference
  Future<void> updateUseHighContrast(bool useHighContrast) async {
    final newConfig = state.copyWith(useHighContrast: useHighContrast);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update font scale
  Future<void> updateFontScale(double fontScale) async {
    final newConfig = state.copyWith(fontScale: fontScale.clamp(0.8, 2.0));
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update color variant
  Future<void> updateColorVariant(ColorVariant colorVariant) async {
    final newConfig = state.copyWith(colorVariant: colorVariant);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update custom seed color
  Future<void> updateCustomSeedColor(Color? customSeedColor) async {
    final newConfig = state.copyWith(
      customSeedColor: customSeedColor,
      colorVariant: customSeedColor != null
          ? ColorVariant.custom
          : ColorVariant.defaultVariant,
    );
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update reduced motion preference
  Future<void> updateReducedMotion(bool reducedMotion) async {
    final newConfig = state.copyWith(reducedMotion: reducedMotion);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update monochrome icons preference
  Future<void> updateUseMonochromeIcons(bool useMonochromeIcons) async {
    final newConfig = state.copyWith(useMonochromeIcons: useMonochromeIcons);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update border radius style
  Future<void> updateBorderRadiusStyle(
    BorderRadiusStyle borderRadiusStyle,
  ) async {
    final newConfig = state.copyWith(borderRadiusStyle: borderRadiusStyle);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update elevation style
  Future<void> updateElevationStyle(ElevationStyle elevationStyle) async {
    final newConfig = state.copyWith(elevationStyle: elevationStyle);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Update typography style
  Future<void> updateTypographyStyle(TypographyStyle typographyStyle) async {
    final newConfig = state.copyWith(typographyStyle: typographyStyle);
    state = newConfig;
    await _themeService.saveThemeConfig(newConfig);
  }

  /// Reset to default configuration
  Future<void> resetToDefaults() async {
    const defaultConfig = ThemeConfig();
    state = defaultConfig;
    await _themeService.saveThemeConfig(defaultConfig);
    await _themeService.clearThemePreferences();
  }

  /// Import theme configuration
  Future<void> importThemeConfig(Map<String, dynamic> configJson) async {
    try {
      final config = ThemeConfig.fromJson(configJson);
      state = config;
      await _themeService.saveThemeConfig(config);
    } catch (e) {
      developer.log(
        'Error importing theme config: $e',
        name: 'ThemeNotifier',
        error: e,
      );
      rethrow;
    }
  }

  /// Export theme configuration
  Map<String, dynamic> exportThemeConfig() {
    return state.toJson();
  }
}

/// Provider for theme service
final themeServiceProvider = Provider<ThemeService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeService(prefs);
});

/// Provider for theme configuration
final themeConfigProvider = StateNotifierProvider<ThemeNotifier, ThemeConfig>((
  ref,
) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeNotifier(themeService);
});

/// Provider for current theme mode (for backward compatibility)
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeConfigProvider).themeMode;
});

/// Provider for dynamic color schemes
final dynamicColorSchemesProvider = FutureProvider<Map<String, ColorScheme>?>((
  ref,
) async {
  try {
    final corePalette = await DynamicColorPlugin.getCorePalette();
    if (corePalette != null) {
      return {
        'light': corePalette.toColorScheme(brightness: Brightness.light),
        'dark': corePalette.toColorScheme(brightness: Brightness.dark),
      };
    }
    return null;
  } catch (e) {
    developer.log(
      'Dynamic colors not available: $e',
      name: 'DynamicColorSchemes',
    );
    return null;
  }
});

/// Provider for light theme data
final lightThemeProvider = Provider<ThemeData>((ref) {
  final config = ref.watch(themeConfigProvider);
  final dynamicColors = ref.watch(dynamicColorSchemesProvider).value;

  return _buildThemeData(
    config: config,
    brightness: Brightness.light,
    dynamicColorScheme: config.useDynamicColors
        ? dynamicColors!['light']
        : null,
  );
});

/// Provider for dark theme data
final darkThemeProvider = Provider<ThemeData>((ref) {
  final config = ref.watch(themeConfigProvider);
  final dynamicColors = ref.watch(dynamicColorSchemesProvider).value;

  return _buildThemeData(
    config: config,
    brightness: Brightness.dark,
    dynamicColorScheme: config.useDynamicColors ? dynamicColors!['dark'] : null,
  );
});

/// Build theme data based on configuration
ThemeData _buildThemeData({
  required ThemeConfig config,
  required Brightness brightness,
  ColorScheme? dynamicColorScheme,
}) {
  // Generate color scheme
  ColorScheme colorScheme;

  switch (config.colorVariant) {
    case ColorVariant.custom:
      colorScheme = DynamicColors.generateCustomColorScheme(
        seedColor: config.customSeedColor ?? DynamicColors.primarySeedColor,
        brightness: brightness,
      );
      break;
    case ColorVariant.defaultVariant:
      colorScheme = brightness == Brightness.light
          ? DynamicColors.generateLightColorScheme(
              dynamicColorScheme: dynamicColorScheme,
            )
          : DynamicColors.generateDarkColorScheme(
              dynamicColorScheme: dynamicColorScheme,
            );
      break;
    case ColorVariant.vibrant:
    case ColorVariant.monochrome:
    case ColorVariant.highContrast:
      final baseScheme = brightness == Brightness.light
          ? DynamicColors.generateLightColorScheme(
              dynamicColorScheme: dynamicColorScheme,
            )
          : DynamicColors.generateDarkColorScheme(
              dynamicColorScheme: dynamicColorScheme,
            );
      final variants = DynamicColors.getColorSchemeVariants(baseScheme);
      colorScheme = variants[config.colorVariant.name] ?? baseScheme;
      break;
  }

  // Apply high contrast if enabled
  if (config.useHighContrast) {
    final variants = DynamicColors.getColorSchemeVariants(colorScheme);
    colorScheme = variants['high_contrast'] ?? colorScheme;
  }

  // Generate financial colors
  final financialColors = DynamicColors.generateFinancialColors(colorScheme);

  // Get configuration values
  final borderRadius = config.borderRadiusConfig;
  final elevation = config.elevationConfig;
  final typography = config.typographyConfig;

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: brightness,

    // Typography with responsive scaling
    textTheme: _buildTextTheme(colorScheme, typography),

    // App bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: elevation.appBar,
      scrolledUnderElevation: elevation.level1,
      shadowColor: colorScheme.shadow.withValues(
        alpha: brightness == Brightness.light ? 0.1 : 0.3,
      ),
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: TextStyle(
        fontSize: typography.titleLarge,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      systemOverlayStyle: brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
    ),

    // Card theme
    cardTheme: CardThemeData(
      elevation: elevation.card,
      shadowColor: colorScheme.shadow.withValues(
        alpha: brightness == Brightness.light ? 0.08 : 0.2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius.card),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: brightness == Brightness.light ? 0.4 : 0.6,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.textField),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.textField),
        borderSide: BorderSide(
          color: colorScheme.outline.withValues(
            alpha: brightness == Brightness.light ? 0.3 : 0.5,
          ),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.textField),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.textField),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius.textField),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: elevation.level1,
        shadowColor: colorScheme.shadow.withValues(
          alpha: brightness == Brightness.light ? 0.1 : 0.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.button),
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.button),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.button),
        ),
        side: BorderSide(color: colorScheme.outline),
      ),
    ),

    // FAB theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: elevation.fab,
      focusElevation: elevation.fab + 2,
      hoverElevation: elevation.fab + 2,
      highlightElevation: elevation.fab + 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius.large),
      ),
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      elevation: elevation.dialog,
      shadowColor: colorScheme.shadow.withValues(
        alpha: brightness == Brightness.light ? 0.15 : 0.3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius.dialog),
      ),
      titleTextStyle: TextStyle(
        fontSize: typography.titleLarge,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      contentTextStyle: TextStyle(
        fontSize: typography.bodyLarge,
        color: colorScheme.onSurfaceVariant,
      ),
    ),

    // Extensions
    extensions: [financialColors],
  );
}

/// Build text theme with responsive typography
TextTheme _buildTextTheme(
  ColorScheme colorScheme,
  TypographyConfig typography,
) {
  final baseTextColor = colorScheme.onSurface;
  final secondaryTextColor = colorScheme.onSurfaceVariant;

  return TextTheme(
    displayLarge: TextStyle(
      fontSize: typography.displayLarge,
      fontWeight: FontWeight.w800,
      color: baseTextColor,
      letterSpacing: -0.25,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    displayMedium: TextStyle(
      fontSize: typography.displayMedium,
      fontWeight: FontWeight.w700,
      color: baseTextColor,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    displaySmall: TextStyle(
      fontSize: typography.displaySmall,
      fontWeight: FontWeight.w600,
      color: baseTextColor,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    headlineLarge: TextStyle(
      fontSize: typography.headlineLarge,
      fontWeight: FontWeight.w700,
      color: baseTextColor,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    headlineMedium: TextStyle(
      fontSize: typography.headlineMedium,
      fontWeight: FontWeight.w600,
      color: baseTextColor,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    headlineSmall: TextStyle(
      fontSize: typography.headlineSmall,
      fontWeight: FontWeight.w600,
      color: baseTextColor,
      letterSpacing: 0,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
    titleLarge: TextStyle(
      fontSize: typography.titleLarge,
      fontWeight: FontWeight.w600,
      color: baseTextColor,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontSize: typography.titleMedium,
      fontWeight: FontWeight.w600,
      color: baseTextColor,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: typography.titleSmall,
      fontWeight: FontWeight.w600,
      color: baseTextColor,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: typography.bodyLarge,
      fontWeight: FontWeight.w400,
      color: baseTextColor,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: typography.bodyMedium,
      fontWeight: FontWeight.w400,
      color: baseTextColor,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: typography.bodySmall,
      fontWeight: FontWeight.w400,
      color: secondaryTextColor,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: typography.labelLarge,
      fontWeight: FontWeight.w600,
      color: baseTextColor,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: typography.labelMedium,
      fontWeight: FontWeight.w600,
      color: secondaryTextColor,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: typography.labelSmall,
      fontWeight: FontWeight.w600,
      color: secondaryTextColor,
      letterSpacing: 0.5,
    ),
  );
}

// SharedPreferences provider is imported from settings viewmodel
