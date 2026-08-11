import 'package:flutter/material.dart';

import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';

/// Shows a styled confirmation dialog before deleting a task.
///
/// Returns `true` if the user confirms deletion.
Future<bool> showDeleteTaskDialog(BuildContext context, Task task) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
  final radii = theme.extension<AppRadii>() ?? AppRadii.standard;
  final layout =
      theme.extension<AppLayoutConstraints>() ?? AppLayoutConstraints.standard;

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.xl,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.lg),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: layout.maxDialogWidth),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_forever_rounded,
                      size: 28,
                      color: colorScheme.error,
                    ),
                  ),
                ),
                SizedBox(height: spacing.md),
                Text(
                  AppStrings.deleteTaskDialogTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.xs),
                Text(
                  AppStrings.deleteTaskDialogBody,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.md),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacing.md),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(radii.md),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.note != null && task.note!.isNotEmpty) ...[
                        SizedBox(height: spacing.xxs),
                        Text(
                          task.note!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: spacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: const Text(AppStrings.cancel),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text(AppStrings.deleteConfirm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  return result ?? false;
}
