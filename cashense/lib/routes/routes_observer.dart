import 'package:flutter/material.dart';
import 'package:cashense/utils/logging/logger.dart';

/// Logs every push/pop/replace so navigation flow shows up in dev logs.
class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    AppLogger.navigation(
      previousRoute?.settings.name ?? '∅',
      route.settings.name ?? '?',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    AppLogger.navigation(
      route.settings.name ?? '?',
      previousRoute?.settings.name ?? '∅',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    AppLogger.navigation(
      oldRoute?.settings.name ?? '∅',
      newRoute?.settings.name ?? '?',
    );
  }
}
