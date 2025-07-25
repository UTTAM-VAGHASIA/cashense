/// Application-wide constants organized by category
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// App information and metadata
  static const String appName = 'Cashense';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered financial management';
  static const String appPackageName = 'com.cashense.app';

  /// Environment configuration
  static const String baseUrl = 'https://api.cashense.com';
  static const String websiteUrl = 'https://cashense.com';
  static const String supportEmail = 'support@cashense.com';
  static const String privacyPolicyUrl = 'https://cashense.com/privacy';
  static const String termsOfServiceUrl = 'https://cashense.com/terms';
}

/// Local storage and caching constants
class StorageConstants {
  StorageConstants._();

  /// Hive box names
  static const String userPrefsBox = 'user_preferences';
  static const String cacheBox = 'cache_data';
  static const String transactionsBox = 'transactions';
  static const String accountsBox = 'accounts';
  static const String budgetsBox = 'budgets';

  /// Secure storage keys
  static const String secureStorageKey = 'cashense_secure';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String biometricKey = 'biometric_enabled';

  /// SharedPreferences keys
  static const String themeModeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String lastSyncKey = 'last_sync';
}

/// UI and design constants
class UIConstants {
  UIConstants._();

  /// Spacing and padding
  static const double extraSmallPadding = 4.0;
  static const double smallPadding = 8.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  /// Border radius values
  static const double smallBorderRadius = 8.0;
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 20.0;

  /// Icon sizes
  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  /// Elevation values
  static const double lowElevation = 2.0;
  static const double defaultElevation = 4.0;
  static const double highElevation = 8.0;

  /// Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration extraLongAnimation = Duration(milliseconds: 800);

  /// Screen breakpoints for responsive design
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
}

/// Financial and business logic constants
class FinancialConstants {
  FinancialConstants._();

  /// Currency and formatting
  static const int maxDecimalPlaces = 2;
  static const String defaultCurrency = 'USD';
  static const String defaultCurrencySymbol = '\$';

  /// Transaction limits
  static const double maxTransactionAmount = 999999999.99;
  static const double minTransactionAmount = 0.01;

  /// Budget and goal constants
  static const int maxBudgetPeriodDays = 365;
  static const int minBudgetPeriodDays = 1;
  static const double maxBudgetAmount = 999999999.99;

  /// Investment constants
  static const double maxInvestmentAmount = 999999999.99;
  static const int maxPortfolioItems = 100;

  /// Categories
  static const int maxCustomCategories = 50;
  static const int maxSubcategories = 20;
}

/// Validation rules and constraints
class ValidationConstants {
  ValidationConstants._();

  /// Authentication
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  /// Text input limits
  static const int maxTransactionDescriptionLength = 255;
  static const int maxCategoryNameLength = 50;
  static const int maxAccountNameLength = 100;
  static const int maxBudgetNameLength = 100;
  static const int maxNoteLength = 500;

  /// File upload limits
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
}

/// Network and API constants
class NetworkConstants {
  NetworkConstants._();

  /// Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Retry configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 1);

  /// Cache configuration
  static const Duration cacheExpiration = Duration(hours: 1);
  static const Duration longCacheExpiration = Duration(days: 1);

  /// Rate limiting
  static const int maxRequestsPerMinute = 60;
  static const Duration rateLimitWindow = Duration(minutes: 1);
}

/// Feature flags and configuration
class FeatureFlags {
  FeatureFlags._();

  /// Core features
  static const bool enableBiometricAuth = true;
  static const bool enableDarkMode = true;
  static const bool enableNotifications = true;

  /// Advanced features
  static const bool enableAIInsights = true;
  static const bool enableInvestmentTracking = true;
  static const bool enableGroupExpenses = true;
  static const bool enableBankSync = false; // Coming soon

  /// Debug features
  static const bool enableDebugMode = false;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableCrashReporting = true;
}

/// Error messages and user-facing text
class ErrorMessages {
  ErrorMessages._();

  /// Network errors
  static const String networkError =
      'Network connection failed. Please check your internet connection.';
  static const String serverError =
      'Server error occurred. Please try again later.';
  static const String timeoutError = 'Request timed out. Please try again.';

  /// Authentication errors
  static const String invalidCredentials = 'Invalid email or password.';
  static const String accountNotFound = 'Account not found.';
  static const String accountDisabled = 'Account has been disabled.';

  /// Validation errors
  static const String requiredField = 'This field is required.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String passwordTooShort =
      'Password must be at least 8 characters long.';
  static const String invalidAmount = 'Please enter a valid amount.';

  /// Generic errors
  static const String unknownError = 'An unexpected error occurred.';
  static const String permissionDenied = 'Permission denied.';
  static const String operationCancelled = 'Operation was cancelled.';
}
