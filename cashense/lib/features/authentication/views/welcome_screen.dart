import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cashense/features/authentication/controllers/authentication_controller.dart';
import 'package:cashense/features/authentication/models/app_user.dart';
import 'package:cashense/utils/constants/sizes.dart';
import 'package:cashense/utils/device/device_utility.dart';

/// Welcome screen displayed after successful authentication
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authController =
        Get.find<AuthenticationController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Sign out button
          Obx(() {
            return IconButton(
              onPressed: authController.isLoading
                  ? null
                  : () => _handleSignOut(authController),
              icon: authController.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.logout,
                      color: colorScheme.onSurfaceVariant,
                    ),
              tooltip: 'Sign out',
            );
          }),
          SizedBox(width: AppSizes.sm),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = AppDeviceUtils.isDesktopScreen(context);
            final isTablet = AppDeviceUtils.isTabletScreen(context);
            final maxWidth = isDesktop
                ? 600.0
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
                            height: isDesktop ? AppSizes.xl * 2 : AppSizes.xl,
                          ),

                          // User profile section
                          Obx(
                            () => _buildProfileSection(
                              authController.user,
                              colorScheme,
                              textTheme,
                              isDesktop,
                            ),
                          ),

                          SizedBox(height: AppSizes.xl * 2),

                          // Welcome message section
                          Obx(
                            () => _buildWelcomeMessage(
                              authController.user,
                              colorScheme,
                              textTheme,
                              isDesktop,
                            ),
                          ),

                          // Spacer to center content
                          const Spacer(),

                          // App info section
                          _buildAppInfoSection(colorScheme, textTheme),

                          // Bottom spacing
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

  /// Build the user profile section with avatar and basic info
  Widget _buildProfileSection(
    AppUser? user,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDesktop,
  ) {
    return Column(
      children: [
        // User avatar
        Container(
          width: isDesktop ? 120 : 100,
          height: isDesktop ? 120 : 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.primaryContainer,
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: user?.photoURL != null
              ? ClipOval(
                  child: Image.network(
                    user!.photoURL!,
                    width: isDesktop ? 120 : 100,
                    height: isDesktop ? 120 : 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(
                        user,
                        colorScheme,
                        textTheme,
                        isDesktop,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : _buildDefaultAvatar(user, colorScheme, textTheme, isDesktop),
        ),

        SizedBox(height: AppSizes.lg),

        // User email (always available)
        if (user?.email != null)
          Text(
            user!.email,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  /// Build default avatar with user initials or icon
  Widget _buildDefaultAvatar(
    AppUser? user,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDesktop,
  ) {
    // Try to get initials from display name or email
    String initials = '';
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      final nameParts = user.displayName!.trim().split(' ');
      if (nameParts.length >= 2) {
        initials = '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
      } else if (nameParts.isNotEmpty) {
        initials = nameParts.first[0].toUpperCase();
      }
    } else if (user?.email != null && user!.email.isNotEmpty) {
      initials = user.email[0].toUpperCase();
    }

    return Center(
      child: initials.isNotEmpty
          ? Text(
              initials,
              style: textTheme.headlineLarge?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: isDesktop ? 48 : 40,
              ),
            )
          : Icon(
              Icons.person,
              size: isDesktop ? 60 : 50,
              color: colorScheme.onPrimaryContainer,
            ),
    );
  }

  /// Build the welcome message section
  Widget _buildWelcomeMessage(
    AppUser? user,
    ColorScheme colorScheme,
    TextTheme textTheme,
    bool isDesktop,
  ) {
    // Determine the greeting based on available user information
    String greeting;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      // Use first name if available
      final firstName = user.firstName ?? user.displayName!.split(' ').first;
      greeting = 'Welcome back, $firstName!';
    } else {
      // Generic welcome message when name is not available
      greeting = 'Welcome to Cashense!';
    }

    return Column(
      children: [
        // Main welcome greeting
        Text(
          greeting,
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: AppSizes.md),

        // Subtitle message
        Text(
          user?.displayName != null
              ? 'Ready to take control of your finances?'
              : 'Get started with intelligent personal finance management.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build the app info section
  Widget _buildAppInfoSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: AppSizes.iconLg,
            color: colorScheme.primary,
          ),

          SizedBox(height: AppSizes.sm),

          Text(
            'Your financial journey starts here',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: AppSizes.sm),

          Text(
            'Track expenses, manage budgets, and achieve your financial goals with Cashense.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Handle sign out with haptic feedback and confirmation
  Future<void> _handleSignOut(AuthenticationController authController) async {
    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Show confirmation dialog
    final bool? shouldSignOut = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      try {
        await authController.signOut();
        // Provide success haptic feedback
        HapticFeedback.mediumImpact();
      } catch (e) {
        // Error handling is managed by the controller
        // Provide error haptic feedback
        HapticFeedback.heavyImpact();
      }
    }
  }
}
