/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// App information
  static const String appName = 'Cashense';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered financial management';

  /// API endpoints (will be configured later)
  static const String baseUrl = 'https://api.cashense.com';

  /// Local storage keys
  static const String userPrefsBox = 'user_preferences';
  static const String cacheBox = 'cache_data';
  static const String secureStorageKey = 'cashense_secure';

  /// UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;

  /// Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  /// Financial constants
  static const int maxDecimalPlaces = 2;
  static const String defaultCurrency = 'USD';

  /// Validation constants
  static const int minPasswordLength = 8;
  static const int maxTransactionDescriptionLength = 255;
}
