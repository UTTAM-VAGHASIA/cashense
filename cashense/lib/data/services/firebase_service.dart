import 'package:firebase_core/firebase_core.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/utils/constants/enums.dart';

// Import the generated options
import 'package:cashense/flavors/firebase/firebase_options_dev.dart' as dev;
import 'package:cashense/flavors/firebase/firebase_options_staging.dart'
    as staging;
import 'package:cashense/flavors/firebase/firebase_options_prod.dart' as prod;

class FirebaseService {
  static Future<void> initializeFirebase() async {
    final flavor = FlavorConfig.instance.flavor;

    FirebaseOptions options;

    switch (flavor) {
      case Flavor.dev:
        options = dev.DefaultFirebaseOptions.currentPlatform;
        break;
      case Flavor.staging:
        options = staging.DefaultFirebaseOptions.currentPlatform;
        break;
      case Flavor.prod:
        options = prod.DefaultFirebaseOptions.currentPlatform;
        break;
    }

    await Firebase.initializeApp(options: options);

    // Optional: Add flavor-specific Firebase configuration
    if (FlavorConfig.isDev()) {
      print('🔥 Firebase initialized for DEV environment');
    } else if (FlavorConfig.isStaging()) {
      print('🔥 Firebase initialized for STAGING environment');
    } else {
      print('🔥 Firebase initialized for PRODUCTION environment');
    }
  }

  static String get currentProjectId {
    return Firebase.app().options.projectId;
  }

  static bool get isInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }
}
