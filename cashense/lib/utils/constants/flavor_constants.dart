import 'package:cashense/utils/constants/enums.dart';
import 'package:flutter/material.dart';

class FlavorSettings {
  final String baseUrl;
  final String name;
  final String appName;
  final String bundleId;
  final bool enableLogging;
  final bool enableAnalytics;
  final String analyticsKey;
  final bool enableCrashlytics;
  final String crashlyticsKey;
  final bool enablePerformanceMonitoring;
  final bool shouldPreviewDevice;
  final FlavorDebugConfig debugConfig;
  final String googleWebClientId;

  const FlavorSettings({
    required this.baseUrl,
    required this.name,
    required this.appName,
    required this.bundleId,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.analyticsKey,
    required this.enableCrashlytics,
    required this.crashlyticsKey,
    required this.enablePerformanceMonitoring,
    required this.shouldPreviewDevice,
    required this.debugConfig,
    required this.googleWebClientId,
  });
}

class FlavorDebugConfig {
  final bool debugMode;
  final bool showPerformanceOverlay;
  final bool enableHotReload;
  final bool showDebugBanner;
  final String bannerMessage;
  final Color bannerColor;

  const FlavorDebugConfig({
    required this.debugMode,
    required this.showPerformanceOverlay,
    required this.enableHotReload,
    required this.showDebugBanner,
    required this.bannerColor,
    required this.bannerMessage,
  });
}

class FlavorConstants {
  static const Map<Flavor, FlavorSettings> configs = {
    Flavor.dev: FlavorSettings(
      baseUrl: 'https://dev.api.com',
      name: 'D E V E L O P M E N T',
      appName: 'Cashense Dev',
      bundleId: 'com.cashense.app.dev',
      enableLogging: true,
      enableAnalytics: false,
      analyticsKey: '',
      enableCrashlytics: false,
      crashlyticsKey: '',
      enablePerformanceMonitoring: false,
      shouldPreviewDevice: true,
      googleWebClientId:
          '380247139382-fr227jiq8gcv1rb6ssaiuf6difjtb4o5.apps.googleusercontent.com',
      debugConfig: FlavorDebugConfig(
        debugMode: true,
        showPerformanceOverlay: true,
        enableHotReload: true,
        showDebugBanner: true,
        bannerColor: Color(0xFFE53E3E),
        bannerMessage: "DEV",
      ),
    ),
    Flavor.staging: FlavorSettings(
      baseUrl: 'https://staging.api.com',
      name: 'S T A G I N G',
      appName: 'Cashense Staging',
      bundleId: 'com.cashense.app.staging',
      enableLogging: true,
      enableAnalytics: true,
      analyticsKey: 'staging_analytics_key',
      enableCrashlytics: true,
      crashlyticsKey: 'staging_crashlytics_key',
      enablePerformanceMonitoring: true,
      shouldPreviewDevice: false,
      googleWebClientId:
          '788140990788-ikuf589ciurklkoucdulqc105326p8mb.apps.googleusercontent.com',
      debugConfig: FlavorDebugConfig(
        debugMode: false,
        showPerformanceOverlay: false,
        enableHotReload: false,
        showDebugBanner: true,
        bannerColor: Color(0xFF3182CE),
        bannerMessage: "STAGING",
      ),
    ),
    Flavor.prod: FlavorSettings(
      baseUrl: 'https://api.cashense.com',
      name: 'P R O D U C T I O N',
      appName: 'Cashense',
      bundleId: 'com.cashense.app',
      enableLogging: false,
      enableAnalytics: true,
      analyticsKey: 'production_analytics_key',
      enableCrashlytics: true,
      crashlyticsKey: 'production_crashlytics_key',
      enablePerformanceMonitoring: true,
      shouldPreviewDevice: false,
      googleWebClientId:
          '1030695688169-925gdk2ras9gj5aouakuvi2t9no4hpcv.apps.googleusercontent.com',
      debugConfig: FlavorDebugConfig(
        debugMode: false,
        showPerformanceOverlay: false,
        enableHotReload: false,
        showDebugBanner: false,
        bannerColor: Colors.transparent,
        bannerMessage: "",
      ),
    ),
  };

  static FlavorSettings getConfig(Flavor flavor) {
    return configs[flavor] ?? _getDefaultConfig();
  }

  static FlavorSettings _getDefaultConfig() {
    return const FlavorSettings(
      baseUrl: 'https://localhost:3000',
      name: 'D E F A U L T',
      appName: 'Cashense Default',
      bundleId: 'com.cashense.app.default',
      enableLogging: true,
      enableAnalytics: false,
      analyticsKey: '',
      enableCrashlytics: false,
      crashlyticsKey: '',
      enablePerformanceMonitoring: false,
      shouldPreviewDevice: false,
      googleWebClientId: 'your-default-web-client-id.googleusercontent.com',
      debugConfig: FlavorDebugConfig(
        debugMode: true,
        showPerformanceOverlay: false,
        enableHotReload: true,
        showDebugBanner: true,
        bannerColor: Color(0xFFFFCCCC),
        bannerMessage: "Default",
      ),
    );
  }
}
