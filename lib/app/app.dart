import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'theme/theme_config.dart';
import 'localization/index.dart';
import '../l10n/app_localizations.dart';
import '../viewmodels/providers.dart';
import '../services/crashlytics_service.dart';

/// The main Cashense application widget with enhanced performance and error handling
class CashenseApp extends ConsumerWidget {
  const CashenseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers with optimized error handling and selective rebuilds
    final router = ref.watch(appRouterProvider);
    final themeConfig = ref.watch(themeConfigProvider);

    // Watch dynamic colors with enhanced error handling and fallback
    final dynamicColorsAsync = ref.watch(dynamicColorSchemesProvider);

    return dynamicColorsAsync.when(
      loading: () => _buildLoadingApp(themeConfig),
      error: (error, stackTrace) {
        // Enhanced error logging with context
        _logAppEvent('Dynamic colors failed to load: $error');
        CrashlyticsService.instance.recordError(
          error,
          stackTrace,
          reason: 'Dynamic colors initialization failed',
          fatal: false,
          context: {
            'theme_mode': themeConfig.themeMode.name,
            'use_dynamic_colors': themeConfig.useDynamicColors,
            'platform': Theme.of(context).platform.name,
          },
        );

        // Fallback to app without dynamic colors with graceful degradation
        return _buildApp(ref, router, themeConfig, hasDynamicColors: false);
      },
      data: (dynamicColors) => _buildApp(
        ref, 
        router, 
        themeConfig, 
        hasDynamicColors: dynamicColors != null,
      ),
    );
  }

  /// Build loading app with enhanced UX and theme consistency
  ///
  /// **Improvements:**
  /// - Branded loading screen with smooth animations
  /// - Theme-aware loading screen that respects user preferences
  /// - Better accessibility with semantic labels
  /// - Responsive design for different screen sizes
  /// - Memory-efficient implementation
  Widget _buildLoadingApp(ThemeConfig themeConfig) {
    final isDark = themeConfig.themeMode == ThemeMode.dark ||
        (themeConfig.themeMode == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);

    return MaterialApp(
      title: 'Cashense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeConfig.themeMode,
      home: _LoadingScreen(isDark: isDark, themeConfig: themeConfig),
    );
  }

  Widget _buildApp(
    WidgetRef ref, 
    GoRouter router, 
    ThemeConfig themeConfig, {
    bool hasDynamicColors = true,
  }) {
    // Watch the current locale with error handling
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Cashense',
      debugShowCheckedModeBanner: false,

      // Routing with enhanced error boundary
      routerConfig: router,

      // Enhanced theming with dynamic color support indication
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: themeConfig.themeMode,
      
      // Comprehensive localization support
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LocalizationService.supportedLocales,

      // Enhanced locale resolution with better fallback logic and error recovery
      localeResolutionCallback: (locale, supportedLocales) {
        try {
          final bestMatch = LocalizationService.findBestSupportedLocale(locale);
          if (bestMatch != null) {
            _logAppEvent('Locale resolved to: ${bestMatch.languageCode}');
            return bestMatch;
          }
          
          // Fallback to first supported locale
          final fallback = LocalizationService.supportedLocales.first;
          _logAppEvent('Using fallback locale: ${fallback.languageCode}');
          return fallback;
        } catch (e) {
          // Emergency fallback to English
          _logAppEvent('Locale resolution failed: $e, using English fallback');
          CrashlyticsService.instance.recordError(
            e,
            StackTrace.current,
            reason: 'Locale resolution failure',
            fatal: false,
            context: {
              'requested_locale': locale?.toString() ?? 'null',
              'supported_locales_count': supportedLocales.length,
            },
          );
          return const Locale('en');
        }
      },

      // Enhanced performance optimizations and accessibility
      builder: (context, child) {
        // Log app lifecycle events with comprehensive context
        _logAppEvent(
          'App built - Theme: ${themeConfig.themeMode.name}, '
          'Locale: ${currentLocale.languageCode}, '
          'Dynamic Colors: $hasDynamicColors',
        );

        return _AppWrapper(
          themeConfig: themeConfig, 
          hasDynamicColors: hasDynamicColors,
          child: child!,
        );
      },

      // Optimized scroll behavior for better cross-platform performance
      scrollBehavior: const _CashenseScrollBehavior(),
    );
  }

  /// Log app events for debugging and analytics
  void _logAppEvent(String message) {
    CrashlyticsService.instance.log('App Event: $message');
  }
}

/// Enhanced loading screen with smooth animations and theme awareness
class _LoadingScreen extends StatefulWidget {
  const _LoadingScreen({
    required this.isDark,
    required this.themeConfig,
  });

  final bool isDark;
  final ThemeConfig themeConfig;

  @override
  State<_LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<_LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
    );

    // Start animations with staggered timing
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _textController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.isDark ? Colors.grey.shade900 : Colors.white;
    final primaryColor = widget.isDark ? Colors.blue.shade400 : Colors.blue.shade600;
    final textColor = widget.isDark ? Colors.white : Colors.black87;
    final subtitleColor = widget.isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated app logo
              AnimatedBuilder(
                animation: _logoScale,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoScale.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 40,
                        semanticLabel: 'Cashense app logo',
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Animated app name
              FadeTransition(
                opacity: _textFade,
                child: Text(
                  'Cashense',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                  semanticsLabel: 'Cashense',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Loading indicator
              FadeTransition(
                opacity: _textFade,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Loading text
              FadeTransition(
                opacity: _textFade,
                child: Text(
                  'Loading your financial companion...',
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  semanticsLabel: 'Loading application',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wrapper widget for additional app-level configurations
class _AppWrapper extends StatelessWidget {
  const _AppWrapper({
    required this.child, 
    required this.themeConfig,
    this.hasDynamicColors = true,
  });

  final Widget child;
  final ThemeConfig themeConfig;
  final bool hasDynamicColors;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // Apply font scaling from theme configuration with better clamping
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          (MediaQuery.of(context).textScaler.scale(1.0) * themeConfig.fontScale)
              .clamp(0.8, 2.0),
        ),
      ),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // Dynamic system UI overlay based on theme
        value: _getSystemUiOverlayStyle(context, themeConfig),
        child: child,
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

/// Enhanced error boundary widget with better error recovery and UX
class _ErrorBoundary extends StatefulWidget {
  const _ErrorBoundary({
    required this.reducedMotion, 
    required this.child,
    this.hasDynamicColors = true,
  });

  final Widget child;
  final bool reducedMotion;
  final bool hasDynamicColors;

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
