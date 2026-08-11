import 'package:flutter/material.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/domain/models/task_stats.dart';

enum _StatKind { total, active, completed }

/// Summary counts for task overview sections.
class TaskStatsPanel extends StatelessWidget {
  const TaskStatsPanel({
    super.key,
    required this.stats,
    this.compact = false,
    this.horizontal = false,
  });

  final TaskStats stats;
  final bool compact;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;

    final tiles = [
      _StatTile(kind: _StatKind.total, value: stats.total),
      _StatTile(kind: _StatKind.active, value: stats.active),
      _StatTile(kind: _StatKind.completed, value: stats.completed),
    ];

    if (horizontal) {
      return Row(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) SizedBox(width: spacing.sm),
            Expanded(child: tiles[i]),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!compact)
          Text(
            AppStrings.overview,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        if (!compact) SizedBox(height: spacing.sm),
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) SizedBox(height: spacing.xs),
          tiles[i],
        ],
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.kind, required this.value});

  final _StatKind kind;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accents = theme.extension<AppAccentColors>() ?? AppAccentColors.light;
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final radii = theme.extension<AppRadii>() ?? AppRadii.standard;
    final isDark = theme.brightness == Brightness.dark;

    final (label, icon, semantic, foreground, lightBackground) = switch (kind) {
      _StatKind.total => (
        AppStrings.statTotal,
        Icons.format_list_bulleted_rounded,
        colorScheme.primary,
        colorScheme.primary,
        colorScheme.primaryContainer,
      ),
      _StatKind.active => (
        AppStrings.statActive,
        Icons.pending_actions_rounded,
        accents.active,
        accents.active,
        accents.activeContainer,
      ),
      _StatKind.completed => (
        AppStrings.statCompleted,
        Icons.check_circle_outline_rounded,
        accents.completed,
        accents.completed,
        accents.completedContainer,
      ),
    };

    final background = isDark
        ? Color.alphaBlend(
            semantic.withValues(alpha: 0.1),
            colorScheme.surfaceContainerHighest,
          )
        : lightBackground;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radii.md),
        border: isDark
            ? Border.all(color: semantic.withValues(alpha: 0.18))
            : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: foreground),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '$value',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
