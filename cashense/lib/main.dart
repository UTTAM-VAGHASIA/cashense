import 'dart:io';

import 'package:cashense/app.dart';
import 'package:cashense/data/services/firebase_service.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/utils/constants/enums.dart';
import 'package:cashense/utils/constants/flavor_constants.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

Future<void> commonMain({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final settings = FlavorConstants.getConfig(flavor);
  FlavorConfig(flavor: flavor, settings: settings);
  
  // Initialize Firebase
  await FirebaseService.initializeFirebase();
  
  runApp(
    DevicePreview(
      enabled:
          FlavorConfig.instance.shouldPreviewDevice &&
          (!Platform.isAndroid && !Platform.isIOS),
      builder: (context) => App(),
    ),
  );
}

Future<void> main() async {
  await commonMain(flavor: Flavor.dev);
}
