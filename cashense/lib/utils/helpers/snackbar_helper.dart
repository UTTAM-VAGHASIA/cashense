import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashense/utils/constants/colors.dart';
import 'package:cashense/utils/constants/sizes.dart';

/// Helper class for showing snackbars throughout the app
class SnackbarHelper {
  SnackbarHelper._();

  /// Show success snackbar
  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success,
      colorText: AppColors.white,
      duration: duration,
      margin: const EdgeInsets.all(AppSizes.md),
      borderRadius: AppSizes.borderRadiusMd,
      icon: const Icon(
        Icons.check_circle_outline,
        color: AppColors.white,
        size: AppSizes.iconMd,
      ),
      shouldIconPulse: false,
      leftBarIndicatorColor: AppColors.successDark,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show error snackbar
  static void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    bool isDismissible = true,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error,
      colorText: AppColors.white,
      duration: duration,
      margin: const EdgeInsets.all(AppSizes.md),
      borderRadius: AppSizes.borderRadiusMd,
      icon: const Icon(
        Icons.error_outline,
        color: AppColors.white,
        size: AppSizes.iconMd,
      ),
      shouldIconPulse: false,
      leftBarIndicatorColor: AppColors.errorDark,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show warning snackbar
  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.warning,
      colorText: AppColors.white,
      duration: duration,
      margin: const EdgeInsets.all(AppSizes.md),
      borderRadius: AppSizes.borderRadiusMd,
      icon: const Icon(
        Icons.warning_amber_outlined,
        color: AppColors.white,
        size: AppSizes.iconMd,
      ),
      shouldIconPulse: false,
      leftBarIndicatorColor: AppColors.warningDark,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show info snackbar
  static void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.info,
      colorText: AppColors.white,
      duration: duration,
      margin: const EdgeInsets.all(AppSizes.md),
      borderRadius: AppSizes.borderRadiusMd,
      icon: const Icon(
        Icons.info_outline,
        color: AppColors.white,
        size: AppSizes.iconMd,
      ),
      shouldIconPulse: false,
      leftBarIndicatorColor: AppColors.infoDark,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show custom snackbar
  static void showCustom({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.TOP,
    bool isDismissible = true,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: duration,
      margin: const EdgeInsets.all(AppSizes.md),
      borderRadius: AppSizes.borderRadiusMd,
      icon: Icon(
        icon,
        color: textColor,
        size: AppSizes.iconMd,
      ),
      shouldIconPulse: false,
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Show loading snackbar
  static void showLoading({
    required String message,
    Duration? duration,
    bool isDismissible = false,
  }) {
    Get.snackbar(
      'Loading',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.grey800,
      colorText: AppColors.white,
      duration: duration,
      margin: const EdgeInsets.all(AppSizes.md),
      borderRadius: AppSizes.borderRadiusMd,
      icon: const SizedBox(
        width: AppSizes.iconMd,
        height: AppSizes.iconMd,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
        ),
      ),
      shouldIconPulse: false,
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: AppColors.grey600,
      progressIndicatorValueColor: const AlwaysStoppedAnimation<Color>(
        AppColors.white,
      ),
      isDismissible: isDismissible,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
    );
  }

  /// Dismiss all snackbars
  static void dismissAll() {
    Get.closeAllSnackbars();
  }

  /// Dismiss current snackbar
  static void dismiss() {
    Get.closeCurrentSnackbar();
  }
}
