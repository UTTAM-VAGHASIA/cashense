import 'package:cashense/data/services/firebase_service.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/utils/constants/enums.dart';
import 'package:cashense/utils/constants/flavor_constants.dart';
import 'package:flutter/material.dart';
import 'package:cashense/flavors/main_development.dart' as dev;

Future<void> commonMain({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = FlavorConstants.getConfig(flavor);
  FlavorConfig(flavor: flavor, settings: settings);

  // Initialize Firebase
  await FirebaseService.initializeFirebase();
}

Future<void> main() async {
  await commonMain(flavor: Flavor.dev);

  dev.main();
}
