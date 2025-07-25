import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'crashlytics_service.dart';

/// Service class to manage Firebase connections and provide status information
class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  /// Check if Firebase is properly initialized
  bool get isInitialized => Firebase.apps.isNotEmpty;

  /// Get Firebase app information
  String get appName => Firebase.app().name;
  String get projectId => Firebase.app().options.projectId;

  /// Get Firebase service instances
  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;

  /// Test Firebase connectivity
  Future<Map<String, dynamic>> testConnectivity() async {
    try {
      final results = <String, dynamic>{};

      // Test Firestore connectivity
      try {
        await firestore.enableNetwork();
        results['firestore'] = 'Connected';
      } catch (e) {
        results['firestore'] = 'Error: $e';
      }

      // Test Auth connectivity
      try {
        await auth.authStateChanges().first.timeout(
          const Duration(seconds: 5),
          onTimeout: () => null,
        );
        results['auth'] = 'Connected';
      } catch (e) {
        results['auth'] = 'Error: $e';
      }

      // Test Storage connectivity
      try {
        storage.ref().child('test');
        results['storage'] = 'Connected';
      } catch (e) {
        results['storage'] = 'Error: $e';
      }

      // Test Crashlytics connectivity
      try {
        final isEnabled = await CrashlyticsService.instance
            .isCrashlyticsCollectionEnabled();
        results['crashlytics'] = isEnabled ? 'Enabled' : 'Disabled';
      } catch (e) {
        results['crashlytics'] = 'Error: $e';
      }

      results['initialized'] = isInitialized;
      results['projectId'] = projectId;
      results['appName'] = appName;

      return results;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
