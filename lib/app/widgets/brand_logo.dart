import 'package:flutter/material.dart';

import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';

/// Branded mark used in headers and the splash screen.
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.size = 48,
    this.showLabel = false,
    this.inverted = false,
  });

  final double size;
  final bool showLabel;

  /// When true, label text is white for use on saturated/gradient backgrounds.
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accents = theme.extension<AppAccentColors>() ?? AppAccentColors.light;

    final labelColor = inverted ? Colors.white : colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [accents.headerGradientStart, accents.headerGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: inverted
                ? null
                : [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Icon(
            Icons.checklist_rounded,
            color: Colors.white,
            size: size * 0.55,
          ),
        ),
        if (showLabel) ...[
          SizedBox(width: size * 0.3),
          Text(
            AppStrings.appName,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: labelColor,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ],
    );
  }
}
