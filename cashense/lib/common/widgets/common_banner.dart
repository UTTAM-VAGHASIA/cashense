import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final BannerLocation location;
  final Widget child;

  const CustomBanner({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    this.location = BannerLocation.topEnd,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: message,
      location: location,
      color: backgroundColor,
      textStyle: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      child: child,
    );
  }
}