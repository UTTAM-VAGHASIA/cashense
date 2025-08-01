import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import the centralized provider
import '../../viewmodels/features/settings/settings_viewmodel.dart'
    show sharedPreferencesProvider;
import 'theme_extensions.dart';
import 'dynamic_colors.dart' hide FinancialColors;
import 'theme_config.dart';

/// Provider for theme mode state management with persistence (backward compatibility)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref.watch(sharedPreferencesProvider)),
);

/// Enhanced theme mode notifier with persistence (backward compatibility)
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final SharedPreferences _prefs;
  static const String _themeModeKey = 'theme_mode';

  /// Load theme mode from persistent storage
  void _loadThemeMode() {
    final savedThemeIndex = _prefs.getInt(_themeModeKey);
    if (savedThemeIndex != null && savedThemeIndex < ThemeMode.values.length) {
      state = ThemeMode.values[savedThemeIndex];
    }
  }

  /// Save theme mode to persistent storage
  Future<void> _saveThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_themeModeKey, mode.index);
  }

  /// Set theme mode with persistence
  Future<void> setThemeMode(ThemeMode mode) async {
    if (state != mode) {
      state = mode;
      await _saveThemeMode(mode);
    }
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system =>
        ThemeMode.light, // Default to light when toggling from system
    };
    await setThemeMode(newMode);
  }

  /// Reset to system theme
  Future<void> resetToSystem() async {
    await setThemeMode(ThemeMode.system);
  }
}

/// Enhanced application theme configuration following Material 3 design
class AppTheme {
  AppTheme._();

  /// Enhanced light theme configuration with dynamic color support
  static ThemeData light([ColorScheme? lightColorScheme]) {
    final colorScheme =
        lightColorScheme ?? DynamicColors.generateLightColorScheme();

    return _buildThemeData(
      colorScheme: colorScheme,
      brightness: Brightness.light,
    );
  }

  /// Enhanced dark theme configuration with dynamic color support
  static ThemeData dark([ColorScheme? darkColorScheme]) {
    final colorScheme =
        darkColorScheme ?? DynamicColors.generateDarkColorScheme();

    return _buildThemeData(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
    );
  }

  /// Build theme data with comprehensive configuration
  static ThemeData _buildThemeData({
    required ColorScheme colorScheme,
    required Brightness brightness,
    ThemeConfig? config,
  }) {
    // Use default config if none provided
    config ??= const ThemeConfig();

    // Get configuration values
    final borderRadius = config.borderRadiusConfig;
    final elevation = config.elevationConfig;
    final typography = config.typographyConfig;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,

      // Enhanced typography with responsive scaling
      textTheme: _buildTextTheme(colorScheme, typography, brightness),

      // Enhanced app bar with better elevation handling
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

      // Enhanced card theme with responsive design
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

      // Enhanced input decoration with better states
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: brightness == Brightness.light ? 0.4 : 0.6,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),

      // Enhanced button themes with responsive design
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

      // Enhanced FAB theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: elevation.fab,
        focusElevation: elevation.fab + 2,
        hoverElevation: elevation.fab + 2,
        highlightElevation: elevation.fab + 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.large),
        ),
      ),

      // Enhanced navigation themes
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        elevation: elevation.navigationBar,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: typography.labelMedium,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: typography.labelMedium,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        elevation: elevation.navigationBar,
        shadowColor: colorScheme.shadow.withValues(
          alpha: brightness == Brightness.light ? 0.1 : 0.2,
        ),
        indicatorColor: colorScheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: typography.labelMedium,
            );
          }
          return TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: typography.labelMedium,
          );
        }),
      ),

      // Enhanced list tile theme
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.medium),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Enhanced chip theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
          fontSize: typography.labelMedium,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.chip),
        ),
      ),

      // Enhanced divider theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      // Enhanced progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),

      // Enhanced snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: colorScheme.onInverseSurface,
          fontSize: typography.bodyMedium,
        ),
        actionTextColor: colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.medium),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Enhanced dialog theme
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

      // Custom extensions for financial app
      extensions: [DynamicColors.generateFinancialColors(colorScheme)],
    );
  }

  /// Enhanced text theme optimized for financial data display
  static TextTheme _buildTextTheme(
    ColorScheme colorScheme,
    TypographyConfig typography,
    Brightness brightness,
  ) {
    // Base text color with better contrast
    final baseTextColor = colorScheme.onSurface;
    final secondaryTextColor = colorScheme.onSurfaceVariant;

    return TextTheme(
      // Display styles for large monetary amounts
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

      // Headline styles for transaction amounts
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

      // Title styles
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

      // Body styles
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

      // Label styles
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
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double fabBorderRadius = 16.0;
  static const double dialogBorderRadius = 20.0;

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
}
