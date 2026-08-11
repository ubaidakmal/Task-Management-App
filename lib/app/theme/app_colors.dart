import 'package:flutter/material.dart';

/// Central color seeds and semantic palette values for light and dark themes.
abstract final class AppColors {
  /// Calm blue-green seed for a professional productivity application.
  static const Color seed = Color(0xFF2F6F8F);

  static const Color lightSurface = Color(0xFFF7F8FA);
  static const Color lightSurfaceContainer = Color(0xFFEEF1F4);
  static const Color darkSurface = Color(0xFF121417);
  static const Color darkSurfaceContainer = Color(0xFF1C2127);

  static const Color lightOutline = Color(0xFFCBD2D9);
  static const Color darkOutline = Color(0xFF3D4652);
}
