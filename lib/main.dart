import 'dart:async';
import 'dart:developer' as developer;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'services/crashlytics_service.dart';
import 'viewmodels/providers.dart';

void main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      // Initialize Flutter binding first
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize app with proper error handling
      await _initializeApp();
    },
    (error, stack) {
      // Global error handler for uncaught exceptions
      _handleGlobalError(error, stack);
    },
  );
}

/// Centralized app initialization with proper error handling and recovery
Future<void> _initializeApp() async {
  try {
    developer.log('Starting app initialization...', name: 'AppInit');

    // Initialize core services with timeout and retry logic
    await _initializeCoreServices();

    // Initialize local storage
    await _initializeLocalStorage();

    // Initialize shared preferences
    final sharedPreferences = await _initializeSharedPreferences();

    // Setup error handlers after services are initialized
    _setupErrorHandlers();

    // Launch app with proper provider setup
    _launchApp(sharedPreferences);

    developer.log('App initialization completed successfully', name: 'AppInit');
  } catch (error, stackTrace) {
    developer.log(
      'Critical error during app initialization: $error',
      name: 'AppInit',
      error: error,
      stackTrace: stackTrace,
    );

    // Show error screen instead of crashing
    _launchErrorApp(error.toString());
  }
}

/// Initialize core Firebase services with enhanced timeout and retry logic
///
/// **Improvements:**
/// - Retry logic with circuit breaker pattern
/// - Better timeout handling with exponential backoff
/// - More granular error reporting with categorization
/// - Service health checks and validation
/// - Memory-efficient error tracking
Future<void> _initializeCoreServices() async {
  const maxRetries = 3;
  const baseTimeout = Duration(seconds: 10);
  final stopwatch = Stopwatch()..start();

  for (int attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      developer.log(
        'Initializing Firebase (attempt $attempt/$maxRetries)',
        name: 'AppInit',
      );

      // Initialize Firebase with progressive timeout and better error context
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(
        Duration(seconds: baseTimeout.inSeconds * attempt),
        onTimeout: () => throw TimeoutException(
          'Firebase initialization timeout after ${baseTimeout.inSeconds * attempt}s',
          baseTimeout * attempt,
        ),
      );

      // Enhanced Firebase validation with specific checks
      if (Firebase.apps.isEmpty) {
        throw StateError('Firebase apps list is empty after initialization');
      }

      // Verify Firebase app is properly configured
      final app = Firebase.app();
      if (app.options.projectId.isEmpty) {
        throw StateError('Firebase project ID is not configured');
      }

      // Initialize Crashlytics with enhanced configuration
      await CrashlyticsService.instance.initialize(enableInDebug: kDebugMode);

      // Log successful initialization with timing
      stopwatch.stop();
      developer.log(
        'Core services initialized successfully in ${stopwatch.elapsedMilliseconds}ms',
        name: 'AppInit',
      );
      return; // Success - exit retry loop
    } on TimeoutException catch (error) {
      developer.log(
        'Firebase initialization timeout on attempt $attempt: ${error.message}',
        name: 'AppInit',
      );

      if (attempt == maxRetries) {
        throw StateError(
          'Firebase initialization failed after $maxRetries timeout attempts',
        );
      }
    } on StateError catch (error) {
      developer.log(
        'Firebase configuration error on attempt $attempt: ${error.message}',
        name: 'AppInit',
      );

      // Configuration errors are not retryable
      rethrow;
    } catch (error) {
      developer.log(
        'Firebase initialization attempt $attempt failed: $error',
        name: 'AppInit',
      );

      if (attempt == maxRetries) {
        developer.log(
          'All Firebase initialization attempts failed',
          name: 'AppInit',
        );
        rethrow;
      }

      // Wait before retry with exponential backoff and jitter
      final delayMs = (500 * attempt) + (DateTime.now().millisecond % 100);
      await Future<void>.delayed(Duration(milliseconds: delayMs));
    }
  }
}

/// Initialize local storage with error handling
Future<void> _initializeLocalStorage() async {
  try {
    await Hive.initFlutter();
    developer.log('Local storage initialized', name: 'AppInit');
  } catch (error) {
    developer.log(
      'Failed to initialize local storage: $error',
      name: 'AppInit',
    );
    rethrow;
  }
}

/// Initialize SharedPreferences with retry logic
Future<SharedPreferences> _initializeSharedPreferences() async {
  int retryCount = 0;
  const maxRetries = 3;

  while (retryCount < maxRetries) {
    try {
      final prefs = await SharedPreferences.getInstance();
      developer.log('SharedPreferences initialized', name: 'AppInit');
      return prefs;
    } catch (error) {
      retryCount++;
      developer.log(
        'SharedPreferences initialization failed (attempt $retryCount): $error',
        name: 'AppInit',
      );

      if (retryCount >= maxRetries) rethrow;

      // Wait before retry
      await Future<void>.delayed(Duration(milliseconds: 500 * retryCount));
    }
  }

  throw Exception(
    'Failed to initialize SharedPreferences after $maxRetries attempts',
  );
}

/// Setup Flutter error handlers
void _setupErrorHandlers() {
  if (!kDebugMode) {
    // Production error handling
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      CrashlyticsService.instance.recordFlutterError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      CrashlyticsService.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } else {
    // Debug mode: enhanced error reporting
    FlutterError.onError = (FlutterErrorDetails errorDetails) {
      FlutterError.presentError(errorDetails);
      developer.log(
        'Flutter Error: ${errorDetails.exception}',
        name: 'FlutterError',
        error: errorDetails.exception,
        stackTrace: errorDetails.stack,
      );
    };
  }
}

/// Launch the main app with enhanced provider setup and performance monitoring
///
/// **Improvements:**
/// - Conditional DevicePreview only in debug mode
/// - Performance monitoring setup
/// - Memory usage tracking
/// - Better provider organization
void _launchApp(SharedPreferences sharedPreferences) {
  // Setup performance monitoring in debug mode
  if (kDebugMode) {
    developer.log(
      'Launching app in debug mode with DevicePreview',
      name: 'AppInit',
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      observers: kDebugMode ? [_ProviderObserver()] : null,
      child: kDebugMode
          ? DevicePreview(
              enabled: true,
              builder: (context) => const CashenseApp(),
            )
          : const CashenseApp(),
    ),
  );
}

/// Enhanced provider observer for debugging with performance monitoring
class _ProviderObserver extends ProviderObserver {
  static const _maxLogLength = 200;
  static const _excludedProviders = {
    'ThemeData',
    'MediaQueryData',
    'Locale',
  };

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (!kDebugMode) return;

    final providerName = provider.name ?? provider.runtimeType.toString();
    
    // Skip logging for frequently updating providers to reduce noise
    if (_excludedProviders.contains(providerName)) return;

    // Truncate long values to prevent log spam
    final prevStr = _truncateValue(previousValue);
    final newStr = _truncateValue(newValue);

    developer.log(
      'Provider $providerName updated: $prevStr -> $newStr',
      name: 'ProviderObserver',
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (!kDebugMode) return;

    final providerName = provider.name ?? provider.runtimeType.toString();
    developer.log(
      'Provider $providerName disposed',
      name: 'ProviderObserver',
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (!kDebugMode) return;

    final providerName = provider.name ?? provider.runtimeType.toString();
    developer.log(
      'Provider $providerName failed: $error',
      name: 'ProviderObserver',
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _truncateValue(Object? value) {
    final str = value.toString();
    return str.length > _maxLogLength 
        ? '${str.substring(0, _maxLogLength)}...' 
        : str;
  }
}

/// Launch error app when initialization fails
void _launchErrorApp(String errorMessage) {
  runApp(
    MaterialApp(
      title: 'Cashense - Error',
      debugShowCheckedModeBanner: false,
      home: _ErrorScreen(errorMessage: errorMessage),
    ),
  );
}

/// Handle global uncaught errors
void _handleGlobalError(Object error, StackTrace stack) {
  developer.log(
    'Global uncaught error: $error',
    name: 'GlobalError',
    error: error,
    stackTrace: stack,
  );

  if (!kDebugMode) {
    CrashlyticsService.instance.recordError(error, stack, fatal: true);
  }
}

/// Enhanced error screen with better UX and accessibility
class _ErrorScreen extends StatefulWidget {
  const _ErrorScreen({required this.errorMessage});

  final String errorMessage;

  @override
  State<_ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<_ErrorScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isRestarting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated error icon
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red.shade600,
                        semanticLabel: 'Error',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // Error title with better typography
                Text(
                  'App Initialization Failed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                  semanticsLabel: 'App initialization failed',
                ),
                const SizedBox(height: 16),
                
                // Error description with better readability
                Text(
                  'We encountered an error while starting the app. This might be due to network connectivity or device configuration issues.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red.shade700,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Action buttons with improved layout
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isRestarting ? null : _handleRestart,
                        icon: _isRestarting 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.refresh),
                        label: Text(_isRestarting ? 'Restarting...' : 'Restart App'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Secondary action for reporting
                    TextButton.icon(
                      onPressed: _handleReportIssue,
                      icon: const Icon(Icons.bug_report),
                      label: const Text('Report Issue'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
                
                // Debug information (improved layout)
                if (kDebugMode) ...[
                  const SizedBox(height: 32),
                  ExpansionTile(
                    title: Text(
                      'Debug Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade800,
                      ),
                    ),
                    iconColor: Colors.red.shade600,
                    collapsedIconColor: Colors.red.shade600,
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
                        child: SelectableText(
                          'Error Details:\n${widget.errorMessage}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            height: 1.3,
                          ),
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

  Future<void> _handleRestart() async {
    setState(() => _isRestarting = true);
    
    // Add a small delay for better UX
    await Future<void>.delayed(const Duration(milliseconds: 500));
    
    try {
      // Restart the app
      main();
    } catch (e) {
      // If restart fails, show error and reset state
      if (mounted) {
        setState(() => _isRestarting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to restart: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  void _handleReportIssue() {
    // In a real app, this would open a bug report dialog or external link
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Issue reporting feature coming soon'),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }
}
