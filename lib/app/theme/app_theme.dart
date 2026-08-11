import 'package:flutter/material.dart';

import 'package:task_management_app/app/theme/app_colors.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';

/// Centralized Material 3 light and dark theme definitions.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
      primary: AppColors.seed,
      secondary: AppColors.secondary,
      tertiary: AppColors.success,
      surface: AppColors.lightSurface,
      surfaceContainerHighest: AppColors.lightSurfaceContainer,
      primaryContainer: AppColors.lightPrimaryContainer,
      secondaryContainer: AppColors.lightSecondaryContainer,
      tertiaryContainer: AppColors.lightSuccessContainer,
      outline: AppColors.lightOutline,
    );

    return _baseTheme(colorScheme, AppAccentColors.light);
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
      primary: const Color(0xFF818CF8),
      onPrimary: const Color(0xFF1E1B4B),
      secondary: const Color(0xFFA78BFA),
      tertiary: const Color(0xFF4ADE80),
      surface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.darkSurfaceContainer,
      primaryContainer: AppColors.darkPrimaryContainer,
      secondaryContainer: AppColors.darkSecondaryContainer,
      tertiaryContainer: AppColors.darkSuccessContainer,
      outline: AppColors.darkOutline,
    );

    return _baseTheme(colorScheme, AppAccentColors.dark);
  }

  static ThemeData _baseTheme(
    ColorScheme colorScheme,
    AppAccentColors accentColors,
  ) {
    final radii = AppRadii.standard;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.full),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radii.sm),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.primary,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.full),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.sm),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.md),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radii.sm),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radii.sm),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radii.sm),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      extensions: [
        AppSpacing.standard,
        AppRadii.standard,
        AppLayoutConstraints.standard,
        accentColors,
      ],
    );
  }
}
