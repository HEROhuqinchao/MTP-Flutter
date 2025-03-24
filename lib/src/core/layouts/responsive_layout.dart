import 'package:flutter/material.dart';

class ScreenBreakpoints {
  static const double mobile = 650;
  static const double tablet = 1100;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? mobileLandscapeLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    this.mobileLandscapeLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (context.isLandscape) {
          return mobileLandscapeLayout ?? mobileLayout;
        } else {
          return mobileLayout;
        }
      },
    );
  }
}

extension ResponsiveExtension on BuildContext {
  bool get isMobile =>
      MediaQuery.of(this).size.width <= ScreenBreakpoints.mobile;
  bool get isTablet =>
      MediaQuery.of(this).size.width > ScreenBreakpoints.mobile &&
      MediaQuery.of(this).size.width <= ScreenBreakpoints.tablet;
  bool get isDesktop =>
      MediaQuery.of(this).size.width > ScreenBreakpoints.tablet;

  // Helper for determining physical device type
  bool get isPhysicalMobile => MediaQuery.of(this).size.shortestSide < 600;

  // Helper for orientation
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;
}
