import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashense/utils/helpers/dialog_helper.dart';
import 'package:cashense/utils/helpers/snackbar_helper.dart';
import 'package:cashense/utils/logging/logger.dart';

/// Helper class for handling app permissions
class PermissionHelper {
  PermissionHelper._();

  /// Request camera permission
  static Future<bool> requestCamera() async {
    try {
      // Note: You'll need to add permission_handler package to pubspec.yaml
      // and import it here for actual permission handling

      AppLogger.info('Requesting camera permission');

      // Placeholder implementation - replace with actual permission logic
      // final status = await Permission.camera.request();
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error requesting camera permission', error: e);
      return false;
    }
  }

  /// Request photo library permission
  static Future<bool> requestPhotos() async {
    try {
      AppLogger.info('Requesting photos permission');

      // Placeholder implementation
      // final status = await Permission.photos.request();
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error requesting photos permission', error: e);
      return false;
    }
  }

  /// Request microphone permission
  static Future<bool> requestMicrophone() async {
    try {
      AppLogger.info('Requesting microphone permission');

      // Placeholder implementation
      // final status = await Permission.microphone.request();
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error requesting microphone permission', error: e);
      return false;
    }
  }

  /// Request location permission
  static Future<bool> requestLocation() async {
    try {
      AppLogger.info('Requesting location permission');

      // Placeholder implementation
      // final status = await Permission.location.request();
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error requesting location permission', error: e);
      return false;
    }
  }

  /// Request notification permission
  static Future<bool> requestNotification() async {
    try {
      AppLogger.info('Requesting notification permission');

      // Placeholder implementation
      // final status = await Permission.notification.request();
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error requesting notification permission', error: e);
      return false;
    }
  }

  /// Request storage permission
  static Future<bool> requestStorage() async {
    try {
      AppLogger.info('Requesting storage permission');

      // Placeholder implementation
      // final status = await Permission.storage.request();
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error requesting storage permission', error: e);
      return false;
    }
  }

  /// Request contacts permission
  static Future<bool> requestContacts() async {
    try {
      AppLogger.info('Requesting contacts permission');

      // Placeholder implementation
      // final status = await Permission.contacts.request();
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error requesting contacts permission', error: e);
      return false;
    }
  }

  /// Check if camera permission is granted
  static Future<bool> hasCameraPermission() async {
    try {
      // Placeholder implementation
      // final status = await Permission.camera.status;
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error checking camera permission', error: e);
      return false;
    }
  }

  /// Check if photos permission is granted
  static Future<bool> hasPhotosPermission() async {
    try {
      // Placeholder implementation
      // final status = await Permission.photos.status;
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error checking photos permission', error: e);
      return false;
    }
  }

  /// Check if location permission is granted
  static Future<bool> hasLocationPermission() async {
    try {
      // Placeholder implementation
      // final status = await Permission.location.status;
      // return status.isGranted;

      return true; // Placeholder
    } catch (e) {
      AppLogger.error('Error checking location permission', error: e);
      return false;
    }
  }

  /// Show permission denied dialog
  static Future<void> showPermissionDeniedDialog({
    required String title,
    required String message,
    required String permissionName,
  }) async {
    await DialogHelper.showCustom(
      title: title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: 48,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            openAppSettings();
          },
          child: const Text('Settings'),
        ),
      ],
    );
  }

  /// Open app settings
  static Future<void> openAppSettings() async {
    try {
      AppLogger.info('Opening app settings');

      // Placeholder implementation
      // await openAppSettings();

      SnackbarHelper.showInfo(
        title: 'Settings',
        message: 'Please enable permissions in app settings',
      );
    } catch (e) {
      AppLogger.error('Error opening app settings', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Could not open app settings',
      );
    }
  }

  /// Request permission with rationale
  static Future<bool> requestWithRationale({
    required Future<bool> Function() requestPermission,
    required String title,
    required String message,
    required String permissionName,
  }) async {
    // First, try to request the permission
    final granted = await requestPermission();

    if (granted) {
      return true;
    }

    // If denied, show rationale dialog
    final shouldShowRationale = await DialogHelper.showConfirmation(
      title: title,
      message: message,
      confirmText: 'Grant Permission',
      cancelText: 'Cancel',
      icon: Icons.security,
    );

    if (shouldShowRationale == true) {
      // Try requesting again
      final secondAttempt = await requestPermission();

      if (!secondAttempt) {
        // Show settings dialog if still denied
        await showPermissionDeniedDialog(
          title: 'Permission Required',
          message:
              'This permission is required for the app to function properly. Please enable it in settings.',
          permissionName: permissionName,
        );
      }

      return secondAttempt;
    }

    return false;
  }

  /// Request multiple permissions
  static Future<Map<String, bool>> requestMultiple(
    List<Future<bool> Function()> permissions,
  ) async {
    final results = <String, bool>{};

    for (int i = 0; i < permissions.length; i++) {
      try {
        final granted = await permissions[i]();
        results['permission_$i'] = granted;
      } catch (e) {
        AppLogger.error('Error requesting permission $i', error: e);
        results['permission_$i'] = false;
      }
    }

    return results;
  }

  /// Check if all required permissions are granted
  static Future<bool> checkAllPermissions(
    List<Future<bool> Function()> permissions,
  ) async {
    for (final permission in permissions) {
      try {
        final granted = await permission();
        if (!granted) {
          return false;
        }
      } catch (e) {
        AppLogger.error('Error checking permission', error: e);
        return false;
      }
    }

    return true;
  }

  /// Show permission explanation bottom sheet
  static Future<bool?> showPermissionExplanation({
    required String title,
    required String description,
    required List<String> features,
    required String permissionName,
  }) async {
    return await DialogHelper.showBottomSheet<bool>(
      title: title,
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: Get.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'This permission allows the app to:',
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('Not Now'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Allow'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
