import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'shared/services/crashlytics_service.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Initialize Firebase Crashlytics
      await CrashlyticsService.instance.initialize(enableInDebug: false);

      if (!kDebugMode) {
        // Only enable Crashlytics in release mode
        FlutterError.onError = (errorDetails) {
          CrashlyticsService.instance.recordFlutterError(errorDetails);
        };
        // Pass all uncaught asynchronous errors to Crashlytics
        PlatformDispatcher.instance.onError = (error, stack) {
          CrashlyticsService.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      // Initialize Hive for local storage
      await Hive.initFlutter();

      // Initialize SharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const CashenseApp(),
        ),
      );
    },
    (error, stack) {
      // Catch any errors that occur outside of Flutter's error handling
      if (!kDebugMode) {
        CrashlyticsService.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}
