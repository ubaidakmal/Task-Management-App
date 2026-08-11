import 'package:flutter/material.dart';

/// Central palette for a calm, minimal productivity application.
abstract final class AppColors {
  /// Prominent indigo seed — strong on light UI, readable on dark UI.
  static const Color seed = Color(0xFF6366F1);

  static const Color secondary = Color(0xFF8B5CF6);
  static const Color success = Color(0xFF22C55E);

  static const Color lightSurface = Color(0xFFF8F9FC);
  static const Color lightSurfaceContainer = Color(0xFFEEF0F8);
  static const Color lightPrimaryContainer = Color(0xFFE0E7FF);
  static const Color lightSecondaryContainer = Color(0xFFEDE9FE);
  static const Color lightSuccessContainer = Color(0xFFDCFCE7);

  static const Color darkSurface = Color(0xFF0F1117);
  static const Color darkSurfaceContainer = Color(0xFF1A1D27);
  static const Color darkPrimaryContainer = Color(0xFF312E81);
  static const Color darkSecondaryContainer = Color(0xFF4C1D95);
  static const Color darkSuccessContainer = Color(0xFF14532D);

  static const Color lightOutline = Color(0xFFC7CBD8);
  static const Color darkOutline = Color(0xFF454B5E);

  /// Primary tone used on splash / native launch screens.
  static const Color splashBackground = Color(0xFF6366F1);
  static const Color splashBackgroundDark = Color(0xFF0F1117);
  static const Color splashGradientEnd = Color(0xFF8B5CF6);
}
