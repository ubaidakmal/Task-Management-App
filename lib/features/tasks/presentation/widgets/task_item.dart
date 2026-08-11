import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/delete_task_dialog.dart';

/// Single task row/card with completion toggle and delete action.
class TaskItem extends ConsumerWidget {
  const TaskItem({super.key, required this.task, this.dense = false});

  final Task task;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return task.isCompleted
        ? _CompletedTaskCard(task: task, dense: dense)
        : _ActiveTaskCard(task: task, dense: dense);
  }
}

class _ActiveTaskCard extends ConsumerWidget {
  const _ActiveTaskCard({required this.task, required this.dense});

  final Task task;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final radii = theme.extension<AppRadii>() ?? AppRadii.standard;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Material(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.md),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _toggle(context, ref),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(radii.md),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      spacing.sm,
                      dense ? spacing.xs : spacing.sm,
                      spacing.xxs,
                      dense ? spacing.xs : spacing.sm,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: spacing.xxs),
                          child: Checkbox(
                            value: false,
                            onChanged: (_) => _toggle(context, ref),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radii.sm),
                            ),
                          ),
                        ),
                        SizedBox(width: spacing.xs),
                        Expanded(
                          child: _TaskContent(task: task, dense: dense),
                        ),
                        _DeleteButton(task: task),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(taskControllerProvider.notifier).toggleTask(task.id);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorUpdateTask)),
        );
      }
    }
  }
}

class _CompletedTaskCard extends ConsumerWidget {
  const _CompletedTaskCard({required this.task, required this.dense});

  final Task task;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accents = theme.extension<AppAccentColors>() ?? AppAccentColors.light;
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final radii = theme.extension<AppRadii>() ?? AppRadii.standard;
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark
        ? Color.alphaBlend(
            accents.completed.withValues(alpha: 0.1),
            colorScheme.surfaceContainerHighest,
          )
        : accents.completedContainer.withValues(alpha: 0.45);

    final borderColor = accents.completed.withValues(
      alpha: isDark ? 0.18 : 0.25,
    );

    final checkBadgeColor = isDark
        ? Color.alphaBlend(
            accents.completed.withValues(alpha: 0.16),
            colorScheme.surfaceContainerHighest,
          )
        : accents.completedContainer;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Material(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.md),
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _toggle(context, ref),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.sm,
              dense ? spacing.xs : spacing.sm,
              spacing.xxs,
              dense ? spacing.xs : spacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: spacing.xxs),
                  child: Material(
                    color: checkBadgeColor,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => _toggle(context, ref),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: accents.completed,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: spacing.xs),
                Expanded(
                  child: _TaskContent(
                    task: task,
                    dense: dense,
                    completed: true,
                  ),
                ),
                _DeleteButton(task: task, muted: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(taskControllerProvider.notifier).toggleTask(task.id);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorUpdateTask)),
        );
      }
    }
  }
}

class _TaskContent extends StatelessWidget {
  const _TaskContent({
    required this.task,
    required this.dense,
    this.completed = false,
  });

  final Task task;
  final bool dense;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: completed ? FontWeight.w500 : FontWeight.w600,
      color: completed ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
    );

    final noteStyle = theme.textTheme.bodyMedium?.copyWith(
      color: colorScheme.onSurfaceVariant.withValues(
        alpha: completed ? 0.75 : 1,
      ),
      height: 1.35,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          style: titleStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (task.note != null && task.note!.isNotEmpty) ...[
          SizedBox(height: theme.extension<AppSpacing>()?.xxs ?? 4),
          Text(
            task.note!,
            style: noteStyle,
            maxLines: dense ? 2 : 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _DeleteButton extends ConsumerWidget {
  const _DeleteButton({required this.task, this.muted = false});

  final Task task;
  final bool muted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: AppStrings.deleteTaskTooltip,
      child: IconButton(
        onPressed: () => _delete(context, ref),
        visualDensity: VisualDensity.compact,
        icon: Icon(
          Icons.delete_outline_rounded,
          color: colorScheme.error.withValues(alpha: muted ? 0.55 : 0.8),
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDeleteTaskDialog(context, task);
    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await ref.read(taskControllerProvider.notifier).deleteTask(task.id);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.errorDeleteTask)),
        );
      }
    }
  }
}
