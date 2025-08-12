import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cashense/utils/logging/logger.dart';

/// Platform-specific authentication configuration helper
class PlatformAuthConfig {
  PlatformAuthConfig._();

  /// Check if Google Sign-In is supported on the current platform
  static bool isGoogleSignInSupported() {
    if (kIsWeb) return true;
    if (Platform.isAndroid) return true;
    if (Platform.isWindows) return true;
    if (Platform.isLinux) return true;
    if (Platform.isMacOS) return true;
    if (Platform.isIOS) return false; // Not yet implemented
    return false;
  }

  /// Get platform-specific configuration requirements
  static Map<String, dynamic> getPlatformRequirements() {
    final requirements = <String, dynamic>{};

    if (kIsWeb) {
      requirements.addAll({
        'platform': 'web',
        'requiresWebClientId': true,
        'requiresAuthorizedDomains': true,
        'configurationFiles': [],
        'notes': [
          'Configure web OAuth client ID in Google Cloud Console',
          'Add authorized domains for your web app',
          'Ensure HTTPS is used in production',
        ],
      });
    } else if (Platform.isAndroid) {
      requirements.addAll({
        'platform': 'android',
        'requiresWebClientId': false,
        'requiresAuthorizedDomains': false,
        'configurationFiles': ['google-services.json'],
        'notes': [
          'Place google-services.json in android/app/ directory',
          'Configure SHA-1 fingerprints in Firebase Console',
          'Ensure package name matches in google-services.json',
        ],
      });
    } else if (Platform.isWindows) {
      requirements.addAll({
        'platform': 'windows',
        'requiresWebClientId': true,
        'requiresAuthorizedDomains': true,
        'configurationFiles': [],
        'notes': [
          'Uses web-based OAuth flow',
          'Configure web OAuth client ID in Google Cloud Console',
          'Add localhost redirect URLs for development',
        ],
      });
    } else if (Platform.isLinux) {
      requirements.addAll({
        'platform': 'linux',
        'requiresWebClientId': true,
        'requiresAuthorizedDomains': true,
        'configurationFiles': [],
        'notes': [
          'Uses web-based OAuth flow',
          'Configure web OAuth client ID in Google Cloud Console',
          'Add localhost redirect URLs for development',
        ],
      });
    } else if (Platform.isMacOS) {
      requirements.addAll({
        'platform': 'macos',
        'requiresWebClientId': true,
        'requiresAuthorizedDomains': true,
        'configurationFiles': [],
        'notes': [
          'Uses web-based OAuth flow',
          'Configure web OAuth client ID in Google Cloud Console',
          'Add localhost redirect URLs for development',
        ],
      });
    } else if (Platform.isIOS) {
      requirements.addAll({
        'platform': 'ios',
        'requiresWebClientId': false,
        'requiresAuthorizedDomains': false,
        'configurationFiles': ['GoogleService-Info.plist'],
        'notes': [
          'iOS support is pending implementation',
          'Will require GoogleService-Info.plist in ios/Runner/',
          'Will need iOS-specific Google Sign-In configuration',
          'Apple Developer account setup required',
        ],
      });
    }

    return requirements;
  }

  /// Validate platform-specific configuration
  static bool validatePlatformConfiguration() {
    try {
      final requirements = getPlatformRequirements();
      final platform = requirements['platform'] as String;

      AppLogger.auth('Validating configuration for platform: $platform');

      // For now, we'll assume configuration is valid
      // In a real implementation, you would check for:
      // - Required configuration files
      // - Environment variables
      // - Network connectivity
      // - Platform-specific requirements

      if (platform == 'ios') {
        AppLogger.auth(
          'iOS platform detected - authentication not yet supported',
        );
        return false;
      }

      AppLogger.auth('Platform configuration validation passed for: $platform');
      return true;
    } catch (e) {
      AppLogger.error('Platform configuration validation failed: $e');
      return false;
    }
  }

  /// Get platform-specific error messages
  static String getPlatformErrorMessage(String errorCode) {
    final platform = getCurrentPlatformName();

    switch (errorCode) {
      case 'platform_not_supported':
        return 'Google Sign-In is not supported on $platform.';
      case 'configuration_missing':
        return 'Google Sign-In configuration is missing for $platform.';
      case 'network_error':
        return 'Network error occurred. Please check your internet connection.';
      case 'user_cancelled':
        return ''; // No message for user cancellation
      case 'service_unavailable':
        return 'Google Sign-In service is temporarily unavailable.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  /// Get current platform name
  static String getCurrentPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isMacOS) return 'macOS';
    return 'Unknown';
  }

  /// Log platform configuration details
  static void logPlatformConfiguration() {
    final requirements = getPlatformRequirements();
    final platform = requirements['platform'] as String;
    final configFiles = requirements['configurationFiles'] as List<dynamic>;
    final notes = requirements['notes'] as List<dynamic>;

    AppLogger.auth('Platform Configuration Details:');
    AppLogger.auth('Platform: $platform');
    AppLogger.auth(
      'Requires Web Client ID: ${requirements['requiresWebClientId']}',
    );
    AppLogger.auth(
      'Requires Authorized Domains: ${requirements['requiresAuthorizedDomains']}',
    );

    if (configFiles.isNotEmpty) {
      AppLogger.auth('Required Configuration Files: ${configFiles.join(', ')}');
    }

    if (notes.isNotEmpty) {
      AppLogger.auth('Configuration Notes:');
      for (final note in notes) {
        AppLogger.auth('  - $note');
      }
    }
  }

  /// Check if platform requires web client ID
  static bool requiresWebClientId() {
    final requirements = getPlatformRequirements();
    return requirements['requiresWebClientId'] as bool? ?? false;
  }

  /// Get redirect URLs for current platform
  static List<String> getRedirectUrls() {
    if (kIsWeb) {
      return [
        'https://localhost:3000',
        'https://dev.cashense.com',
        'https://staging.cashense.com',
        'https://cashense.com',
      ];
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return [
        'http://localhost:8080',
        'http://127.0.0.1:8080',
      ];
    }
    return [];
  }
}
