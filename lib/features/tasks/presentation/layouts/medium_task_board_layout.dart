import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/app/widgets/brand_logo.dart';
import 'package:task_management_app/app/widgets/theme_mode_button.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_stats_provider.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_list_section.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_stats_panel.dart';

/// Large phone / small tablet layout with centered content and dialog creation.
class MediumTaskBoardLayout extends ConsumerWidget {
  const MediumTaskBoardLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final layout =
        theme.extension<AppLayoutConstraints>() ??
        AppLayoutConstraints.standard;
    final stats = ref.watch(taskStatsProvider);

    return Scaffold(
      key: TaskBoardKeys.mediumLayout,
      appBar: AppBar(
        title: const Text(AppStrings.taskBoardTitle),
        actions: const [
          ThemeModeButton(),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: BrandLogo(size: 34),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: TaskBoardKeys.addTaskFab,
        onPressed: () => showMediumAddTaskDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addTask),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: layout.maxFormWidth),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.lg,
                spacing.lg,
                spacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TaskBoardHeader(),
                  SizedBox(height: spacing.lg),
                  TaskStatsPanel(stats: stats, horizontal: true),
                  SizedBox(height: spacing.lg),
                  const Expanded(child: TaskListSection(listBottomPadding: 88)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
