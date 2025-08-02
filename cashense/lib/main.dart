import 'dart:io';

import 'package:cashense/app.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/utils/constants/enums.dart';
import 'package:cashense/utils/constants/flavor_constants.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void commonMain({required Flavor flavor}) {
  final settings = FlavorConstants.getConfig(flavor);

  FlavorConfig(flavor: flavor, settings: settings);
  runApp(
    DevicePreview(
      enabled:
          FlavorConfig.instance.shouldPreviewDevice &&
          (!Platform.isAndroid && !Platform.isIOS),
      builder: (context) => App(),
    ),
  );
}

void main() {
  commonMain(flavor: Flavor.dev);
}
