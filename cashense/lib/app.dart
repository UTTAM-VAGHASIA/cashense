import 'package:cashense/bindings/general_bindings.dart';
import 'package:cashense/common/widgets/common_banner.dart';
import 'package:cashense/features/authentication/controllers/authentication_controller.dart';
import 'package:cashense/features/authentication/views/login_screen.dart';
import 'package:cashense/features/authentication/views/welcome_screen.dart';
import 'package:cashense/flavors/flavor_config.dart';
import 'package:cashense/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final debugConfig = FlavorConfig.instance.debugConfig;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      title: FlavorConfig.instance.appName,

      // Initialize general bindings for dependency injection
      initialBinding: GeneralBindings(),

      // Set up authentication-aware routing
      home: (debugConfig.showDebugBanner)
          ? CustomBanner(
              message: debugConfig.bannerMessage,
              backgroundColor: debugConfig.bannerColor,
              textColor: _getContrastColor(debugConfig.bannerColor),
              location: BannerLocation.topEnd,
              child: const AuthenticationWrapper(),
            )
          : const AuthenticationWrapper(),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    // Calculate luminance to determine if we need light or dark text
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Wrapper widget that handles authentication-aware routing
/// Determines initial route based on authentication state
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthenticationController>(
      init: Get.find<AuthenticationController>(),
      builder: (authController) {
        return Obx(() {
          // Show loading screen while checking authentication state
          if (authController.isLoading && authController.user == null) {
            return const AuthenticationLoadingScreen();
          }

          // Navigate based on authentication state
          if (authController.isAuthenticated && authController.user != null) {
            return const WelcomeScreen();
          } else {
            return const LoginScreen();
          }
        });
      },
    );
  }
}

/// Loading screen shown while checking authentication state
class AuthenticationLoadingScreen extends StatelessWidget {
  const AuthenticationLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or branding
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                size: 40,
                color: colorScheme.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 24),

            // App name
            Text(
              'Cashense',
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 32),

            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),

            const SizedBox(height: 16),

            // Loading text
            Text(
              'Loading...',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
