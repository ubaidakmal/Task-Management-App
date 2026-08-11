import 'package:flutter/material.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/domain/models/task_filter.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';

/// Contextual empty state for the task list.
class TaskEmptyState extends StatelessWidget {
  const TaskEmptyState({
    super.key,
    required this.filter,
    required this.hasAnyTasks,
  });

  final TaskFilter filter;
  final bool hasAnyTasks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accents = theme.extension<AppAccentColors>() ?? AppAccentColors.light;
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final content = _content();

    final iconBackground = switch (content.tone) {
      _EmptyTone.neutral => colorScheme.primaryContainer,
      _EmptyTone.active => accents.activeContainer,
      _EmptyTone.completed => accents.completedContainer,
    };
    final iconColor = switch (content.tone) {
      _EmptyTone.neutral => colorScheme.primary,
      _EmptyTone.active => accents.active,
      _EmptyTone.completed => accents.completed,
    };

    return Center(
      key: TaskBoardKeys.taskEmptyState,
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(content.icon, size: 32, color: iconColor),
            ),
            SizedBox(height: spacing.md),
            Text(
              content.headline,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xs),
            Text(
              content.supporting,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  _EmptyContent _content() {
    if (!hasAnyTasks) {
      return const _EmptyContent(
        icon: Icons.task_alt_outlined,
        headline: AppStrings.emptyNoTasksTitle,
        supporting: AppStrings.emptyNoTasksBody,
        tone: _EmptyTone.neutral,
      );
    }

    return switch (filter) {
      TaskFilter.active => const _EmptyContent(
        icon: Icons.check_circle_outline,
        headline: AppStrings.emptyNoActiveTitle,
        supporting: AppStrings.emptyNoActiveBody,
        tone: _EmptyTone.active,
      ),
      TaskFilter.completed => const _EmptyContent(
        icon: Icons.radio_button_unchecked,
        headline: AppStrings.emptyNoCompletedTitle,
        supporting: AppStrings.emptyNoCompletedBody,
        tone: _EmptyTone.completed,
      ),
      TaskFilter.all => const _EmptyContent(
        icon: Icons.task_alt_outlined,
        headline: AppStrings.emptyNoTasksTitle,
        supporting: AppStrings.emptyNoTasksBody,
        tone: _EmptyTone.neutral,
      ),
    };
  }
}

enum _EmptyTone { neutral, active, completed }

class _EmptyContent {
  const _EmptyContent({
    required this.icon,
    required this.headline,
    required this.supporting,
    required this.tone,
  });

  final IconData icon;
  final String headline;
  final String supporting;
  final _EmptyTone tone;
}
