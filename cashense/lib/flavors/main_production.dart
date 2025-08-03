import 'dart:io';

import 'package:cashense/app.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/main.dart';
import 'package:cashense/utils/constants/enums.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await commonMain(flavor: Flavor.prod);

  runApp(
    DevicePreview(
      enabled:
          FlavorConfig.instance.shouldPreviewDevice &&
          (!Platform.isAndroid && !Platform.isIOS),
      builder: (context) => App(),
    ),
  );
}
