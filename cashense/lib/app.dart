import 'package:cashense/common/widgets/common_banner.dart';
import 'package:cashense/features/authentication/views/biometrics_page.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final debugConfig = FlavorConfig.instance.debugConfig;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
        useMaterial3: true
      ),
      darkTheme: ThemeData(),

      title: FlavorConfig.instance.appName,
      home: (debugConfig.showDebugBanner)
          ? CustomBanner(
              message: debugConfig.bannerMessage,
              backgroundColor: debugConfig.bannerColor,
              textColor: _getContrastColor(debugConfig.bannerColor),
              location: BannerLocation.topEnd,
              child: BiometricsPage(),
            )
          : BiometricsPage(),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    // Calculate luminance to determine if we need light or dark text
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
