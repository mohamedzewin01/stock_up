import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 400;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Responsive padding
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 20.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 40.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 60.0);
    }
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  // Responsive text sizes
  static double getHeadlineSize(BuildContext context) {
    if (isSmallScreen(context)) {
      return 24.0;
    } else if (isMobile(context)) {
      return 28.0;
    } else if (isTablet(context)) {
      return 32.0;
    } else {
      return 36.0;
    }
  }

  static double getBodyTextSize(BuildContext context) {
    if (isSmallScreen(context)) {
      return 14.0;
    } else if (isMobile(context)) {
      return 16.0;
    } else {
      return 18.0;
    }
  }

  static double getSubtitleSize(BuildContext context) {
    if (isSmallScreen(context)) {
      return 12.0;
    } else if (isMobile(context)) {
      return 14.0;
    } else {
      return 16.0;
    }
  }

  // Responsive spacing
  static double getVerticalSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 24.0;
    } else if (isTablet(context)) {
      return 32.0;
    } else {
      return 40.0;
    }
  }

  static double getHorizontalSpacing(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  // Responsive logo size
  static double getLogoSize(BuildContext context) {
    if (isSmallScreen(context)) {
      return 80.0;
    } else if (isMobile(context)) {
      return 100.0;
    } else if (isTablet(context)) {
      return 120.0;
    } else {
      return 140.0;
    }
  }

  // Responsive button height
  static double getButtonHeight(BuildContext context) {
    if (isSmallScreen(context)) {
      return 48.0;
    } else if (isMobile(context)) {
      return 56.0;
    } else {
      return 64.0;
    }
  }

  // Container max width for centering content on large screens
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 600.0;
    } else {
      return double.infinity;
    }
  }

  // Responsive widget builder
  static Widget responsive({
    required BuildContext context,
    Widget? mobile,
    Widget? tablet,
    Widget? desktop,
    required Widget fallback,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    } else if (isTablet(context) && tablet != null) {
      return tablet;
    } else if (isMobile(context) && mobile != null) {
      return mobile;
    }
    return fallback;
  }

  // Safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
      left: mediaQuery.padding.left,
      right: mediaQuery.padding.right,
    );
  }

  // Keyboard aware padding
  static EdgeInsets getKeyboardPadding(BuildContext context) {
    return EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    );
  }
}

// Extension for easier usage
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  bool get isSmallScreen => ResponsiveHelper.isSmallScreen(this);

  double get screenWidth => ResponsiveHelper.getScreenWidth(this);
  double get screenHeight => ResponsiveHelper.getScreenHeight(this);

  EdgeInsets get responsivePadding => ResponsiveHelper.getResponsivePadding(this);
  EdgeInsets get horizontalPadding => ResponsiveHelper.getHorizontalPadding(this);

  double get headlineSize => ResponsiveHelper.getHeadlineSize(this);
  double get bodyTextSize => ResponsiveHelper.getBodyTextSize(this);
  double get subtitleSize => ResponsiveHelper.getSubtitleSize(this);

  double get logoSize => ResponsiveHelper.getLogoSize(this);
  double get buttonHeight => ResponsiveHelper.getButtonHeight(this);

  double get verticalSpacing => ResponsiveHelper.getVerticalSpacing(this);
  double get horizontalSpacing => ResponsiveHelper.getHorizontalSpacing(this);

  double get maxContentWidth => ResponsiveHelper.getMaxContentWidth(this);

  EdgeInsets get safeAreaPadding => ResponsiveHelper.getSafeAreaPadding(this);
  EdgeInsets get keyboardPadding => ResponsiveHelper.getKeyboardPadding(this);
}