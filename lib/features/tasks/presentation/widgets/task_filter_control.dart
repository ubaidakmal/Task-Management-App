import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/domain/models/task_filter.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_filter_provider.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';

/// Filter control for All / Active / Completed tasks.
class TaskFilterControl extends ConsumerWidget {
  const TaskFilterControl({super.key});

  static const _filters = TaskFilter.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(taskFilterProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;

    return LayoutBuilder(
      key: TaskBoardKeys.taskFilterControl,
      builder: (context, constraints) {
        if (constraints.maxWidth >= 480) {
          return SegmentedButton<TaskFilter>(
            segments: _filters
                .map(
                  (filter) => ButtonSegment<TaskFilter>(
                    value: filter,
                    label: Text(_labelFor(filter)),
                    icon: Icon(_iconFor(filter), size: 18),
                  ),
                )
                .toList(growable: false),
            selected: {selected},
            onSelectionChanged: (selection) {
              ref.read(taskFilterProvider.notifier).setFilter(selection.first);
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colorScheme.primary;
                }
                return colorScheme.onSurfaceVariant;
              }),
            ),
            showSelectedIcon: false,
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final filter in _filters) ...[
                FilterChip(
                  avatar: Icon(
                    _iconFor(filter),
                    size: 16,
                    color: selected == filter
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  label: Text(_labelFor(filter)),
                  selected: selected == filter,
                  onSelected: (_) {
                    ref.read(taskFilterProvider.notifier).setFilter(filter);
                  },
                ),
                SizedBox(width: spacing.xs),
              ],
            ],
          ),
        );
      },
    );
  }

  static String _labelFor(TaskFilter filter) {
    return switch (filter) {
      TaskFilter.all => AppStrings.filterAll,
      TaskFilter.active => AppStrings.filterActive,
      TaskFilter.completed => AppStrings.filterCompleted,
    };
  }

  static IconData _iconFor(TaskFilter filter) {
    return switch (filter) {
      TaskFilter.all => Icons.view_list_rounded,
      TaskFilter.active => Icons.pending_actions_rounded,
      TaskFilter.completed => Icons.check_circle_outline_rounded,
    };
  }
}
