import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:cashense/features/authentication/controllers/authentication_controller.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/device/device_utility.dart';

/// Material You-compliant login screen with Google Sign-In functionality
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authController =
        Get.find<AuthenticationController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = AppDeviceUtils.isDesktopScreen(context);
            final isTablet = AppDeviceUtils.isTabletScreen(context);
            final maxWidth = isDesktop
                ? 400.0
                : (isTablet ? 500.0 : double.infinity);

            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: maxWidth,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? AppSizes.xl : AppSizes.lg,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Top spacing
                          SizedBox(
                            height: isDesktop
                                ? AppSizes.xl * 2
                                : AppSizes.xl * 1.5,
                          ),

                          // Cashense Logo and Branding
                          _buildBrandingSection(
                            colorScheme,
                            textTheme,
                            isDesktop,
                          ),

                          // Spacer to push content to center
                          const Spacer(),

                          // Welcome Text
                          _buildWelcomeSection(
                            textTheme,
                            colorScheme,
                            isDesktop,
                          ),

                          SizedBox(
                            height: isDesktop ? AppSizes.xl * 1.5 : AppSizes.xl,
                          ),

                          // Google Sign-In Button with loading and error states
                          _buildSignInSection(
                            authController,
                            colorScheme,
                            textTheme,
                          ),

                          // Bottom spacing
                          const Spacer(),
                          SizedBox(height: AppSizes.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build the branding section with Cashense logo
  Widget _buildBrandingSection(
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDesktop,
  ) {
    return Column(
      children: [
        // App Logo
        Container(
          width: isDesktop ? 140 : 120,
          height: isDesktop ? 140 : 120,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.lg),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/logos/app_logo.svg',
              width: isDesktop ? 100 : 80,
              height: isDesktop ? 100 : 80,
              colorFilter: ColorFilter.mode(
                colorScheme.onPrimaryContainer,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),

        SizedBox(height: AppSizes.lg),

        // App Name
        Text(
          'Cashense',
          style: textTheme.headlineLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w900,
          ),
        ),

        SizedBox(height: AppSizes.sm),

        // Tagline
        Text(
          'Smart money management made simple',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build the welcome section with greeting text
  Widget _buildWelcomeSection(
    TextTheme textTheme,
    ColorScheme colorScheme,
    bool isDesktop,
  ) {
    return Column(
      children: [
        Text(
          'Welcome to Cashense',
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: AppSizes.md),

        Text(
          'Sign in with your Google account to get started with intelligent personal finance management.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build the sign-in section with Google button, loading states, and error handling
  Widget _buildSignInSection(
    AuthenticationController authController,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        // Error Message Display
        Obx(() {
          if (authController.hasError) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: AppSizes.md),
              padding: EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                border: Border.all(
                  color: colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colorScheme.onErrorContainer,
                    size: AppSizes.iconMd,
                  ),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      authController.errorMessage,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => authController.clearError(),
                    icon: Icon(
                      Icons.close,
                      color: colorScheme.onErrorContainer,
                      size: 18,
                    ),
                    constraints: BoxConstraints(
                      minWidth: AppSizes.xl,
                      minHeight: AppSizes.xl,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        // Google Sign-In Button
        Obx(() {
          return SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: authController.isLoading
                  ? null
                  : () => _handleGoogleSignIn(authController),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                disabledForegroundColor: colorScheme.onSurfaceVariant,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.md),
                ),
              ),
              icon: authController.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : _buildGoogleIcon(),
              label: Text(
                authController.isLoading
                    ? 'Signing in...'
                    : 'Sign in with Google',
                style: textTheme.titleMedium?.copyWith(
                  color: authController.isLoading
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),

        SizedBox(height: AppSizes.lg),

        // Platform availability note
        if (!Get.find<AuthenticationController>().isGoogleSignInAvailable())
          Container(
            padding: EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppSizes.iconSm,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: AppSizes.sm),
                Text(
                  'Google Sign-In not available on this platform',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Build Google icon for the sign-in button
  Widget _buildGoogleIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Color(0xFF4285F4), // Google Blue
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  /// Handle Google Sign-In with haptic feedback
  Future<void> _handleGoogleSignIn(
    AuthenticationController authController,
  ) async {
    // Provide haptic feedback
    HapticFeedback.lightImpact();

    try {
      final success = await authController.signInWithGoogle();

      if (success) {
        // Provide success haptic feedback
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      // Error handling is managed by the controller
      // Provide error haptic feedback
      HapticFeedback.heavyImpact();
    }
  }
}
