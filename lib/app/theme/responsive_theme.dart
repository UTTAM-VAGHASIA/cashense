import 'package:flutter/material.dart';

/// Responsive design utilities for theme adaptation across different screen sizes
class ResponsiveTheme {
  ResponsiveTheme._();

  /// Screen size breakpoints following Material Design guidelines
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 840;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1600;

  /// Get the current screen type based on width
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < mobileBreakpoint) {
      return ScreenType.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenType.mobileLarge;
    } else if (width < desktopBreakpoint) {
      return ScreenType.tablet;
    } else if (width < largeDesktopBreakpoint) {
      return ScreenType.desktop;
    } else {
      return ScreenType.largeDesktop;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return const EdgeInsets.all(16);
      case ScreenType.mobileLarge:
        return const EdgeInsets.all(20);
      case ScreenType.tablet:
        return const EdgeInsets.all(24);
      case ScreenType.desktop:
        return const EdgeInsets.all(32);
      case ScreenType.largeDesktop:
        return const EdgeInsets.all(40);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ScreenType.mobileLarge:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case ScreenType.tablet:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ScreenType.desktop:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
      case ScreenType.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    }
  }

  /// Get responsive card width based on screen size
  static double getResponsiveCardWidth(BuildContext context) {
    final screenType = getScreenType(context);
    final screenWidth = MediaQuery.of(context).size.width;

    switch (screenType) {
      case ScreenType.mobile:
        return screenWidth - 32; // Full width with padding
      case ScreenType.mobileLarge:
        return screenWidth - 40;
      case ScreenType.tablet:
        return (screenWidth * 0.8).clamp(400, 600);
      case ScreenType.desktop:
        return (screenWidth * 0.6).clamp(500, 800);
      case ScreenType.largeDesktop:
        return (screenWidth * 0.5).clamp(600, 1000);
    }
  }

  /// Get responsive font size multiplier
  static double getFontSizeMultiplier(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return 1.0;
      case ScreenType.mobileLarge:
        return 1.05;
      case ScreenType.tablet:
        return 1.1;
      case ScreenType.desktop:
        return 1.15;
      case ScreenType.largeDesktop:
        return 1.2;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(
    BuildContext context, {
    double baseSize = 24,
  }) {
    final multiplier = getFontSizeMultiplier(context);
    return baseSize * multiplier;
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(
    BuildContext context, {
    double baseRadius = 12,
  }) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return baseRadius;
      case ScreenType.mobileLarge:
        return baseRadius * 1.1;
      case ScreenType.tablet:
        return baseRadius * 1.2;
      case ScreenType.desktop:
        return baseRadius * 1.3;
      case ScreenType.largeDesktop:
        return baseRadius * 1.4;
    }
  }

  /// Get responsive elevation
  static double getResponsiveElevation(
    BuildContext context, {
    double baseElevation = 2,
  }) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return baseElevation;
      case ScreenType.mobileLarge:
        return baseElevation * 1.1;
      case ScreenType.tablet:
        return baseElevation * 1.2;
      case ScreenType.desktop:
        return baseElevation * 1.3;
      case ScreenType.largeDesktop:
        return baseElevation * 1.4;
    }
  }

  /// Get responsive grid column count
  static int getResponsiveGridColumns(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return 1;
      case ScreenType.mobileLarge:
        return 2;
      case ScreenType.tablet:
        return 3;
      case ScreenType.desktop:
        return 4;
      case ScreenType.largeDesktop:
        return 5;
    }
  }

  /// Get responsive navigation type
  static NavigationType getResponsiveNavigationType(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
      case ScreenType.mobileLarge:
        return NavigationType.bottomNavigation;
      case ScreenType.tablet:
        return NavigationType.navigationRail;
      case ScreenType.desktop:
      case ScreenType.largeDesktop:
        return NavigationType.navigationDrawer;
    }
  }

  /// Get responsive app bar height
  static double getResponsiveAppBarHeight(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return kToolbarHeight;
      case ScreenType.mobileLarge:
        return kToolbarHeight + 4;
      case ScreenType.tablet:
        return kToolbarHeight + 8;
      case ScreenType.desktop:
        return kToolbarHeight + 12;
      case ScreenType.largeDesktop:
        return kToolbarHeight + 16;
    }
  }

  /// Get responsive dialog width
  static double getResponsiveDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.mobile:
        return screenWidth * 0.9;
      case ScreenType.mobileLarge:
        return screenWidth * 0.8;
      case ScreenType.tablet:
        return (screenWidth * 0.7).clamp(400, 600);
      case ScreenType.desktop:
        return (screenWidth * 0.5).clamp(500, 700);
      case ScreenType.largeDesktop:
        return (screenWidth * 0.4).clamp(600, 800);
    }
  }
}

/// Screen type enumeration
enum ScreenType { mobile, mobileLarge, tablet, desktop, largeDesktop }

/// Navigation type enumeration
enum NavigationType { bottomNavigation, navigationRail, navigationDrawer }

/// Extension to add responsive utilities to BuildContext
extension ResponsiveExtension on BuildContext {
  /// Get screen type
  ScreenType get screenType => ResponsiveTheme.getScreenType(this);

  /// Check if mobile
  bool get isMobile => ResponsiveTheme.isMobile(this);

  /// Check if tablet
  bool get isTablet => ResponsiveTheme.isTablet(this);

  /// Check if desktop
  bool get isDesktop => ResponsiveTheme.isDesktop(this);

  /// Get responsive padding
  EdgeInsets get responsivePadding =>
      ResponsiveTheme.getResponsivePadding(this);

  /// Get responsive margin
  EdgeInsets get responsiveMargin => ResponsiveTheme.getResponsiveMargin(this);

  /// Get responsive card width
  double get responsiveCardWidth =>
      ResponsiveTheme.getResponsiveCardWidth(this);

  /// Get font size multiplier
  double get fontSizeMultiplier => ResponsiveTheme.getFontSizeMultiplier(this);

  /// Get responsive icon size
  double responsiveIconSize({double baseSize = 24}) =>
      ResponsiveTheme.getResponsiveIconSize(this, baseSize: baseSize);

  /// Get responsive border radius
  double responsiveBorderRadius({double baseRadius = 12}) =>
      ResponsiveTheme.getResponsiveBorderRadius(this, baseRadius: baseRadius);

  /// Get responsive elevation
  double responsiveElevation({double baseElevation = 2}) =>
      ResponsiveTheme.getResponsiveElevation(
        this,
        baseElevation: baseElevation,
      );

  /// Get responsive grid columns
  int get responsiveGridColumns =>
      ResponsiveTheme.getResponsiveGridColumns(this);

  /// Get responsive navigation type
  NavigationType get responsiveNavigationType =>
      ResponsiveTheme.getResponsiveNavigationType(this);

  /// Get responsive app bar height
  double get responsiveAppBarHeight =>
      ResponsiveTheme.getResponsiveAppBarHeight(this);

  /// Get responsive dialog width
  double get responsiveDialogWidth =>
      ResponsiveTheme.getResponsiveDialogWidth(this);
}

/// Responsive widget builder
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.mobileLarge,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  final Widget mobile;
  final Widget? mobileLarge;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  @override
  Widget build(BuildContext context) {
    final screenType = context.screenType;

    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.mobileLarge:
        return mobileLarge ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobileLarge ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobileLarge ?? mobile;
      case ScreenType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobileLarge ?? mobile;
    }
  }
}

/// Responsive value selector
class ResponsiveValue<T> {
  const ResponsiveValue({
    required this.mobile,
    this.mobileLarge,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  final T mobile;
  final T? mobileLarge;
  final T? tablet;
  final T? desktop;
  final T? largeDesktop;

  T getValue(BuildContext context) {
    final screenType = context.screenType;

    switch (screenType) {
      case ScreenType.mobile:
        return mobile;
      case ScreenType.mobileLarge:
        return mobileLarge ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobileLarge ?? mobile;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobileLarge ?? mobile;
      case ScreenType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobileLarge ?? mobile;
    }
  }
}

/// Extension to get responsive values
extension ResponsiveValueExtension<T> on ResponsiveValue<T> {
  T of(BuildContext context) => getValue(context);
}
