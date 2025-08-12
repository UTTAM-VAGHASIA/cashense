import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:cashense/utils/logging/logger.dart';
import 'package:cashense/utils/helpers/snackbar_helper.dart';

/// Helper class for URL operations and launching external apps
class UrlHelper {
  UrlHelper._();

  /// Launch URL in browser
  static Future<bool> launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching URL: $url');
        return await launcher.launchUrl(uri);
      } else {
        AppLogger.warning('Cannot launch URL: $url');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'Cannot open this link',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching URL: $url', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open link',
      );
      return false;
    }
  }

  /// Launch URL in external browser
  static Future<bool> launchInBrowser(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching URL in browser: $url');
        return await launcher.launchUrl(
          uri,
          mode: launcher.LaunchMode.externalApplication,
        );
      } else {
        AppLogger.warning('Cannot launch URL in browser: $url');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'Cannot open this link in browser',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching URL in browser: $url', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open link in browser',
      );
      return false;
    }
  }

  /// Launch URL in in-app browser
  static Future<bool> launchInApp(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching URL in app: $url');
        return await launcher.launchUrl(
          uri,
          mode: launcher.LaunchMode.inAppBrowserView,
        );
      } else {
        AppLogger.warning('Cannot launch URL in app: $url');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'Cannot open this link in app',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching URL in app: $url', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open link in app',
      );
      return false;
    }
  }

  /// Launch email client
  static Future<bool> launchEmail({
    required String email,
    String? subject,
    String? body,
    List<String>? cc,
    List<String>? bcc,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        query: _buildEmailQuery(
          subject: subject,
          body: body,
          cc: cc,
          bcc: bcc,
        ),
      );

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching email client for: $email');
        return await launcher.launchUrl(uri);
      } else {
        AppLogger.warning('Cannot launch email client for: $email');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'No email client available',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching email client', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open email client',
      );
      return false;
    }
  }

  /// Launch phone dialer
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      final uri = Uri(scheme: 'tel', path: phoneNumber);

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching phone dialer for: $phoneNumber');
        return await launcher.launchUrl(uri);
      } else {
        AppLogger.warning('Cannot launch phone dialer for: $phoneNumber');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'Cannot make phone calls',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching phone dialer', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open phone dialer',
      );
      return false;
    }
  }

  /// Launch SMS app
  static Future<bool> launchSms({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      final uri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        query: message != null ? 'body=${Uri.encodeComponent(message)}' : null,
      );

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching SMS app for: $phoneNumber');
        return await launcher.launchUrl(uri);
      } else {
        AppLogger.warning('Cannot launch SMS app for: $phoneNumber');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'Cannot send SMS',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching SMS app', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open SMS app',
      );
      return false;
    }
  }

  /// Launch WhatsApp
  static Future<bool> launchWhatsApp({
    required String phoneNumber,
    String? message,
  }) async {
    try {
      // Remove any non-digit characters from phone number
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

      final uri = Uri.parse(
        'https://wa.me/$cleanNumber${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
      );

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching WhatsApp for: $phoneNumber');
        return await launcher.launchUrl(uri);
      } else {
        AppLogger.warning('Cannot launch WhatsApp for: $phoneNumber');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'WhatsApp is not installed',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching WhatsApp', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open WhatsApp',
      );
      return false;
    }
  }

  /// Launch Google Maps with coordinates
  static Future<bool> launchMaps({
    double? latitude,
    double? longitude,
    String? address,
  }) async {
    try {
      String url;

      if (latitude != null && longitude != null) {
        url =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      } else if (address != null) {
        url =
            'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
      } else {
        SnackbarHelper.showError(
          title: 'Error',
          message: 'No location provided',
        );
        return false;
      }

      final uri = Uri.parse(url);

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching Google Maps');
        return await launcher.launchUrl(uri);
      } else {
        AppLogger.warning('Cannot launch Google Maps');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'Cannot open maps',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching Google Maps', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open maps',
      );
      return false;
    }
  }

  /// Launch app store page
  static Future<bool> launchAppStore({
    required String appId,
    bool isAndroid = false,
  }) async {
    try {
      String url;

      if (isAndroid) {
        url = 'https://play.google.com/store/apps/details?id=$appId';
      } else {
        url = 'https://apps.apple.com/app/id$appId';
      }

      final uri = Uri.parse(url);

      if (await launcher.canLaunchUrl(uri)) {
        AppLogger.info('Launching app store for: $appId');
        return await launcher.launchUrl(uri);
      } else {
        AppLogger.warning('Cannot launch app store for: $appId');
        SnackbarHelper.showError(
          title: 'Error',
          message: 'Cannot open app store',
        );
        return false;
      }
    } catch (e) {
      AppLogger.error('Error launching app store', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open app store',
      );
      return false;
    }
  }

  /// Launch social media profile
  static Future<bool> launchSocialMedia({
    required String platform,
    required String username,
  }) async {
    try {
      String url;

      switch (platform.toLowerCase()) {
        case 'twitter':
        case 'x':
          url = 'https://twitter.com/$username';
          break;
        case 'instagram':
          url = 'https://instagram.com/$username';
          break;
        case 'facebook':
          url = 'https://facebook.com/$username';
          break;
        case 'linkedin':
          url = 'https://linkedin.com/in/$username';
          break;
        case 'youtube':
          url = 'https://youtube.com/@$username';
          break;
        case 'tiktok':
          url = 'https://tiktok.com/@$username';
          break;
        default:
          SnackbarHelper.showError(
            title: 'Error',
            message: 'Unsupported social media platform',
          );
          return false;
      }

      return await launchInBrowser(url);
    } catch (e) {
      AppLogger.error('Error launching social media profile', error: e);
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Failed to open social media profile',
      );
      return false;
    }
  }

  /// Validate URL format
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(phoneNumber) &&
        phoneNumber.replaceAll(RegExp(r'[^\d]'), '').length >= 10;
  }

  /// Build email query string
  static String? _buildEmailQuery({
    String? subject,
    String? body,
    List<String>? cc,
    List<String>? bcc,
  }) {
    final params = <String>[];

    if (subject != null) {
      params.add('subject=${Uri.encodeComponent(subject)}');
    }

    if (body != null) {
      params.add('body=${Uri.encodeComponent(body)}');
    }

    if (cc != null && cc.isNotEmpty) {
      params.add('cc=${cc.map((e) => Uri.encodeComponent(e)).join(',')}');
    }

    if (bcc != null && bcc.isNotEmpty) {
      params.add('bcc=${bcc.map((e) => Uri.encodeComponent(e)).join(',')}');
    }

    return params.isNotEmpty ? params.join('&') : null;
  }

  /// Extract domain from URL
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  /// Check if URL is secure (HTTPS)
  static bool isSecureUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }
}
