import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/app/widgets/brand_logo.dart';
import 'package:task_management_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:task_management_app/features/tasks/presentation/providers/filtered_tasks_provider.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_filter_provider.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_form.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_empty_state.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_filter_control.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_item.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';

/// Shared task list section used across adaptive layouts.
class TaskListSection extends ConsumerWidget {
  const TaskListSection({
    super.key,
    this.showSectionHeader = true,
    this.denseItems = false,
    this.listBottomPadding = 0,
  });

  final bool showSectionHeader;
  final bool denseItems;
  final double listBottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final tasksAsync = ref.watch(taskControllerProvider);
    final filteredTasks = ref.watch(filteredTasksProvider);
    final filter = ref.watch(taskFilterProvider);

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _TaskLoadError(
        onRetry: () => ref.read(taskControllerProvider.notifier).reloadTasks(),
      ),
      data: (allTasks) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showSectionHeader) ...[
              Text(
                AppStrings.tasksSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.sm),
            ],
            const TaskFilterControl(),
            SizedBox(height: spacing.md),
            Expanded(
              child: filteredTasks.isEmpty
                  ? TaskEmptyState(
                      filter: filter,
                      hasAnyTasks: allTasks.isNotEmpty,
                    )
                  : ListView.builder(
                      key: TaskBoardKeys.taskList,
                      padding: EdgeInsets.only(bottom: listBottomPadding),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        return TaskItem(
                          task: filteredTasks[index],
                          dense: denseItems,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _TaskLoadError extends StatelessWidget {
  const _TaskLoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40, color: theme.colorScheme.error),
            SizedBox(height: spacing.md),
            Text(
              AppStrings.errorLoadTasksTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xs),
            Text(
              AppStrings.errorLoadTasksBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            FilledButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared app header for task board layouts.
class TaskBoardHeader extends StatelessWidget {
  const TaskBoardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandLogo(size: 40, showLabel: true),
        SizedBox(height: spacing.sm),
        Text(
          AppStrings.tagline,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Opens the compact add-task bottom sheet.
Future<void> showCompactAddTaskSheet(BuildContext context) {
  final theme = Theme.of(context);
  final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
  final radii = theme.extension<AppRadii>() ?? AppRadii.standard;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: theme.colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(radii.lg)),
    ),
    builder: (sheetContext) {
      final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;

      return Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.md,
          spacing.sm,
          spacing.md,
          spacing.md + bottomInset,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: spacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(radii.full),
                  ),
                ),
              ),
              TaskForm(
                autofocusTitle: true,
                onSuccess: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Opens the medium-width add-task dialog.
Future<void> showMediumAddTaskDialog(BuildContext context) {
  final layout =
      Theme.of(context).extension<AppLayoutConstraints>() ??
      AppLayoutConstraints.standard;
  final spacing =
      Theme.of(context).extension<AppSpacing>() ?? AppSpacing.standard;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final maxHeight = MediaQuery.sizeOf(dialogContext).height * 0.85;

      return Dialog(
        key: TaskBoardKeys.addTaskDialog,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: layout.maxDialogWidth,
            maxHeight: maxHeight,
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: SingleChildScrollView(
              child: TaskForm(
                autofocusTitle: true,
                onSuccess: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          ),
        ),
      );
    },
  );
}
