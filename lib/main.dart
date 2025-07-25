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

/// Initialize core Firebase services with timeout and retry
Future<void> _initializeCoreServices() async {
  try {
    // Initialize Firebase with timeout
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () =>
          throw TimeoutException('Firebase initialization timeout'),
    );

    // Initialize Crashlytics
    await CrashlyticsService.instance.initialize(enableInDebug: kDebugMode);

    developer.log('Core services initialized', name: 'AppInit');
  } catch (error) {
    developer.log(
      'Failed to initialize core services: $error',
      name: 'AppInit',
    );
    rethrow;
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

/// Launch the main app with proper provider setup
void _launchApp(SharedPreferences sharedPreferences) {
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: kDebugMode
          ? DevicePreview(
              enabled: true, // Only enabled in debug mode
              builder: (context) => const CashenseApp(),
            )
          : const CashenseApp(), // Production: no DevicePreview wrapper
    ),
  );
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

/// Error screen shown when app initialization fails
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade600),
              const SizedBox(height: 24),
              Text(
                'App Initialization Failed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We encountered an error while starting the app. Please try restarting.',
                style: TextStyle(fontSize: 16, color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (kDebugMode) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    'Debug Info:\n$errorMessage',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              ElevatedButton.icon(
                onPressed: () {
                  // Restart the app
                  main();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Restart App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
