import 'package:cashense/bindings/general_bindings.dart';
import 'package:cashense/common/widgets/common_banner.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/routes/app_route_pages.dart';
import 'package:cashense/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final debugConfig = FlavorConfig.instance.debugConfig;
    final router = AppRoutePages.router;

    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      title: FlavorConfig.instance.appName,

      // Initialize global dependencies before any route builder runs.
      initialBinding: GeneralBindings(),

      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      backButtonDispatcher: router.backButtonDispatcher,

      builder: debugConfig.showDebugBanner
          ? (context, child) => CustomBanner(
              message: debugConfig.bannerMessage,
              backgroundColor: debugConfig.bannerColor,
              textColor: _getContrastColor(debugConfig.bannerColor),
              location: BannerLocation.topEnd,
              child: child ?? const SizedBox.shrink(),
            )
          : null,
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
