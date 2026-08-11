import 'package:flutter/material.dart';

import 'package:task_management_app/app/responsive/app_breakpoints.dart';
import 'package:task_management_app/app/responsive/responsive_layout.dart';
import 'package:task_management_app/app/responsive/responsive_value.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_constants.dart';

/// Temporary shell screen that verifies theme and responsive wiring.
///
/// Will be replaced by the Task Board in a later step.
class FoundationHomeScreen extends StatelessWidget {
  const FoundationHomeScreen({super.key});

  static const _contentPadding = ResponsiveValue<EdgeInsets>(
    compact: EdgeInsets.all(16),
    medium: EdgeInsets.all(24),
    expanded: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    large: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final layout =
        theme.extension<AppLayoutConstraints>() ??
        AppLayoutConstraints.standard;

    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final breakpoint = AppBreakpoints.breakpointForWidth(
              constraints.maxWidth,
            );
            final padding = _contentPadding.resolveForWidth(
              constraints.maxWidth,
            );

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: layout.maxContentWidth),
                child: SingleChildScrollView(
                  padding: padding,
                  child: ResponsiveLayout(
                    compact: _FoundationPanel(
                      breakpoint: breakpoint,
                      spacing: spacing,
                      columns: 1,
                    ),
                    medium: _FoundationPanel(
                      breakpoint: breakpoint,
                      spacing: spacing,
                      columns: 1,
                    ),
                    expanded: _FoundationPanel(
                      breakpoint: breakpoint,
                      spacing: spacing,
                      columns: 2,
                    ),
                    large: _FoundationPanel(
                      breakpoint: breakpoint,
                      spacing: spacing,
                      columns: 2,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FoundationPanel extends StatelessWidget {
  const _FoundationPanel({
    required this.breakpoint,
    required this.spacing,
    required this.columns,
  });

  final AppBreakpoint breakpoint;
  final AppSpacing spacing;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brightnessLabel = theme.brightness == Brightness.dark
        ? 'Dark'
        : 'Light';

    final cards = [
      _InfoCard(
        title: 'Foundation ready',
        description:
            'Project architecture, Riverpod, Material 3 themes, and '
            'responsive helpers are wired. Task Board features come next.',
        icon: Icons.architecture_outlined,
      ),
      _InfoCard(
        title: 'Active layout tier',
        description:
            '${AppBreakpoints.labelFor(breakpoint)} '
            '(width-based, not platform-based). Resize the window to verify.',
        icon: Icons.aspect_ratio_outlined,
      ),
      _InfoCard(
        title: 'Theme mode',
        description:
            '$brightnessLabel theme active. The app follows system appearance '
            'via ThemeMode.system.',
        icon: Icons.palette_outlined,
      ),
    ];

    if (columns <= 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cross-Platform Task Board',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            'Engineering foundation — responsive layout verification',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.lg),
          for (final card in cards) ...[card, SizedBox(height: spacing.md)],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Cross-Platform Task Board',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.xs),
        Text(
          'Engineering foundation — responsive layout verification',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cards[0]),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                children: [
                  cards[1],
                  SizedBox(height: spacing.md),
                  cards[2],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: spacing.xxs),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
