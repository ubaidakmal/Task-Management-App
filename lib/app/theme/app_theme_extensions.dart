import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Shared spacing tokens referenced across layouts and components.
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  static const AppSpacing standard = AppSpacing(
    xxs: 4,
    xs: 8,
    sm: 12,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  );

  @override
  AppSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) {
      return this;
    }

    return AppSpacing(
      xxs: lerpDouble(xxs, other.xxs, t)!,
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
      xxl: lerpDouble(xxl, other.xxl, t)!,
    );
  }
}

/// Shared corner radius tokens.
@immutable
class AppRadii extends ThemeExtension<AppRadii> {
  const AppRadii({
    required this.sm,
    required this.md,
    required this.lg,
    required this.full,
  });

  final double sm;
  final double md;
  final double lg;
  final double full;

  static const AppRadii standard = AppRadii(sm: 8, md: 12, lg: 16, full: 999);

  @override
  AppRadii copyWith({double? sm, double? md, double? lg, double? full}) {
    return AppRadii(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      full: full ?? this.full,
    );
  }

  @override
  AppRadii lerp(ThemeExtension<AppRadii>? other, double t) {
    if (other is! AppRadii) {
      return this;
    }

    return AppRadii(
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      full: lerpDouble(full, other.full, t)!,
    );
  }
}

/// Layout width constraints for readable content on large displays.
@immutable
class AppLayoutConstraints extends ThemeExtension<AppLayoutConstraints> {
  const AppLayoutConstraints({
    required this.maxContentWidth,
    required this.maxFormWidth,
    required this.maxDialogWidth,
  });

  final double maxContentWidth;
  final double maxFormWidth;
  final double maxDialogWidth;

  static const AppLayoutConstraints standard = AppLayoutConstraints(
    maxContentWidth: 1200,
    maxFormWidth: 560,
    maxDialogWidth: 480,
  );

  @override
  AppLayoutConstraints copyWith({
    double? maxContentWidth,
    double? maxFormWidth,
    double? maxDialogWidth,
  }) {
    return AppLayoutConstraints(
      maxContentWidth: maxContentWidth ?? this.maxContentWidth,
      maxFormWidth: maxFormWidth ?? this.maxFormWidth,
      maxDialogWidth: maxDialogWidth ?? this.maxDialogWidth,
    );
  }

  @override
  AppLayoutConstraints lerp(
    ThemeExtension<AppLayoutConstraints>? other,
    double t,
  ) {
    if (other is! AppLayoutConstraints) {
      return this;
    }

    return AppLayoutConstraints(
      maxContentWidth: lerpDouble(maxContentWidth, other.maxContentWidth, t)!,
      maxFormWidth: lerpDouble(maxFormWidth, other.maxFormWidth, t)!,
      maxDialogWidth: lerpDouble(maxDialogWidth, other.maxDialogWidth, t)!,
    );
  }
}
