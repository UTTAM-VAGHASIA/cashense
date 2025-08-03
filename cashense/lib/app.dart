import 'package:cashense/common/widgets/common_banner.dart';
import 'package:cashense/features/authentication/views/biometrics_page.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final debugConfig = FlavorConfig.instance.debugConfig;

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

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
