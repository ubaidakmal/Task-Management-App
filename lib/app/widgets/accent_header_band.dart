import 'package:flutter/material.dart';

import 'package:task_management_app/app/theme/app_theme_extensions.dart';

/// Subtle branded header band used at the top of task board layouts.
class AccentHeaderBand extends StatelessWidget {
  const AccentHeaderBand({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  static const Color _foreground = Colors.white;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final accents = theme.extension<AppAccentColors>() ?? AppAccentColors.light;
    final radii = theme.extension<AppRadii>() ?? AppRadii.standard;

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accents.headerGradientStart, accents.headerGradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(radii.lg),
      ),
      child: IconTheme(
        data: const IconThemeData(color: _foreground, size: 20),
        child: DefaultTextStyle(
          style: theme.textTheme.bodyMedium!.copyWith(color: _foreground),
          child: child,
        ),
      ),
    );
  }
}
