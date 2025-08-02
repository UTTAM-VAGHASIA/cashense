import 'package:cashense/utils/constants/enums.dart';
import 'package:cashense/utils/constants/flavor_constants.dart';

class FlavorConfig {
  final Flavor flavor;
  final FlavorSettings settings;

  static FlavorConfig? _instance;

  FlavorConfig._({required this.flavor, required this.settings});

  factory FlavorConfig({
    required Flavor flavor,
    required FlavorSettings settings,
  }) {
    _instance ??= FlavorConfig._(flavor: flavor, settings: settings);
    return _instance!;
  }

  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorConfig not initialized');
    }
    return _instance!;
  }

  // Convenience getters
  String get baseUrl => settings.baseUrl;
  String get name => settings.name;
  String get appName => settings.appName;
  String get bundleId => settings.bundleId;
  bool get enableLogging => settings.enableLogging;
  bool get enableAnalytics => settings.enableAnalytics;
  String get analyticsKey => settings.analyticsKey;
  bool get enableCrashlytics => settings.enableCrashlytics;
  String get crashlyticsKey => settings.crashlyticsKey;
  bool get enablePerformanceMonitoring => settings.enablePerformanceMonitoring;
  bool get shouldPreviewDevice => settings.shouldPreviewDevice;
  FlavorDebugConfig get debugConfig => settings.debugConfig;

  // Static helper methods
  static bool isDev() => instance.flavor == Flavor.dev;
  static bool isStaging() => instance.flavor == Flavor.staging;
  static bool isProduction() => instance.flavor == Flavor.prod;
}
