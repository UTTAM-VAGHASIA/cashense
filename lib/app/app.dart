import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'theme/theme_config.dart';
import '../l10n/app_localizations.dart';
import '../viewmodels/providers.dart';
import '../services/crashlytics_service.dart';

/// The main Cashense application widget with enhanced performance and error handling
class CashenseApp extends ConsumerWidget {
  const CashenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers with error handling
    final router = ref.watch(appRouterProvider);
    final themeConfig = ref.watch(themeConfigProvider);

    // Watch dynamic colors
    final dynamicColorsAsync = ref.watch(dynamicColorSchemesProvider);

    return dynamicColorsAsync.when(
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (_, _) => _buildApp(ref, router, themeConfig, null, null),
      data: (dynamicColors) => _buildApp(
        ref,
        router,
        themeConfig,
        null, // Dynamic colors handled in theme providers
        null, // Dynamic colors handled in theme providers
      ),
    );
  }

  Widget _buildApp(
    WidgetRef ref,
    GoRouter router,
    ThemeConfig themeConfig,
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic,
  ) {
    return MaterialApp.router(
      title: 'Cashense',
      debugShowCheckedModeBanner: false,

      // Routing with error boundary
      routerConfig: router,

      // Enhanced theming with dynamic colors and comprehensive configuration
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: themeConfig.themeMode,

      // Comprehensive localization support
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // Locale resolution with fallback
      localeResolutionCallback: (locale, supportedLocales) {
        // Try to match exact locale
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }

        // Try to match language code only
        for (final supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }

        // Fallback to English
        return const Locale('en', 'US');
      },

      // Enhanced performance optimizations and accessibility
      builder: (context, child) {
        // Log app lifecycle events
        _logAppEvent('App built with theme: ${themeConfig.themeMode.name}');

        return _AppWrapper(themeConfig: themeConfig, child: child!);
      },

      // Scroll behavior optimization
      scrollBehavior: const _CashenseScrollBehavior(),
    );
  }

  /// Log app events for debugging and analytics
  void _logAppEvent(String message) {
    CrashlyticsService.instance.log('App Event: $message');
  }
}

/// Wrapper widget for additional app-level configurations
class _AppWrapper extends StatelessWidget {
  const _AppWrapper({required this.child, required this.themeConfig});

  final Widget child;
  final ThemeConfig themeConfig;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // Apply font scaling from theme configuration
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          (MediaQuery.of(context).textScaler.scale(1.0) * themeConfig.fontScale)
              .clamp(0.8, 2.0),
        ),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // Dynamic system UI overlay based on theme
        value: _getSystemUiOverlayStyle(context, themeConfig),
        child: _ErrorBoundary(
          reducedMotion: themeConfig.reducedMotion,
          child: child,
        ),
      ),
    );
  }

  /// Get system UI overlay style based on current theme
  SystemUiOverlayStyle _getSystemUiOverlayStyle(
    BuildContext context,
    ThemeConfig themeConfig,
  ) {
    final brightness = themeConfig.getBrightness(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarColor: colorScheme.surface,
      systemNavigationBarIconBrightness: brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
      systemNavigationBarDividerColor: colorScheme.outline.withValues(
        alpha: 0.1,
      ),
    );
  }
}

/// Error boundary widget to catch and handle widget errors gracefully
class _ErrorBoundary extends StatefulWidget {
  const _ErrorBoundary({required this.reducedMotion, required this.child});

  final Widget child;
  final bool reducedMotion;

  @override
  State<_ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<_ErrorBoundary> {
  bool _hasError = false;
  Object? _error;
  StackTrace? _stackTrace;

  @override
  void initState() {
    super.initState();

    // Set up error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _error = details.exception;
          _stackTrace = details.stack;
        });
      }

      // Log to Crashlytics
      CrashlyticsService.instance.recordFlutterError(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _ErrorWidget(
        error: _error.toString(),
        stackTrace: _stackTrace,
        onRetry: () {
          setState(() {
            _hasError = false;
            _error = null;
            _stackTrace = null;
          });
        },
      );
    }

    return widget.child;
  }
}

/// Widget shown when an error occurs in the app
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    required this.error,
    required this.onRetry,
    this.stackTrace,
  });

  final String error;
  final StackTrace? stackTrace;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 24),
                const Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'The app encountered an unexpected error. Please try again.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),

                // Show debug information in debug mode
                if (kDebugMode && (error.isNotEmpty || stackTrace != null)) ...[
                  const SizedBox(height: 32),
                  ExpansionTile(
                    title: const Text(
                      'Debug Information',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (error.isNotEmpty) ...[
                              const Text(
                                'Error:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                error,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                            if (stackTrace != null) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Stack Trace:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                stackTrace.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'monospace',
                                ),
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom scroll behavior for better cross-platform experience
class _CashenseScrollBehavior extends ScrollBehavior {
  const _CashenseScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // Use platform-appropriate scroll physics
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const BouncingScrollPhysics();
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Show scrollbars on desktop platforms
    switch (getPlatform(context)) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return Scrollbar(controller: details.controller, child: child);
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return child;
    }
  }
}
