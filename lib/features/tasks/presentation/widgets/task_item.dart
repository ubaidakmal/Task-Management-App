import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/presentation/controllers/task_controller.dart';

/// Single task row/card with completion toggle and delete action.
class TaskItem extends ConsumerWidget {
  const TaskItem({super.key, required this.task, this.dense = false});

  final Task task;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accents = theme.extension<AppAccentColors>() ?? AppAccentColors.light;
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final radii = theme.extension<AppRadii>() ?? AppRadii.standard;

    final accentColor = task.isCompleted
        ? accents.completed
        : colorScheme.primary;
    final accentContainer = task.isCompleted
        ? accents.completedContainer
        : colorScheme.primaryContainer;

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
      color: task.isCompleted
          ? colorScheme.onSurfaceVariant
          : colorScheme.onSurface,
    );

    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: accentColor),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: dense ? spacing.xs : spacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: spacing.xxs),
                      decoration: BoxDecoration(
                        color: accentContainer,
                        borderRadius: BorderRadius.circular(radii.sm),
                      ),
                      child: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggle(context, ref),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: titleStyle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (task.note != null && task.note!.isNotEmpty) ...[
                            SizedBox(height: spacing.xxs),
                            Text(
                              task.note!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                height: 1.35,
                              ),
                              maxLines: dense ? 2 : 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Tooltip(
                      message: AppStrings.deleteTaskTooltip,
                      child: IconButton(
                        onPressed: () => _delete(context, ref),
                        icon: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error.withValues(alpha: 0.75),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
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
