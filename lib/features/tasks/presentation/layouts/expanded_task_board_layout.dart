import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/app/widgets/accent_header_band.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/app/widgets/theme_mode_button.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_stats_provider.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_form.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_list_section.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_stats_panel.dart';

/// Desktop-oriented sidebar + task content layout for expanded and large widths.
class ExpandedTaskBoardLayout extends ConsumerWidget {
  const ExpandedTaskBoardLayout({super.key});

  static const double _sidebarWidth = 320;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final layout =
        theme.extension<AppLayoutConstraints>() ??
        AppLayoutConstraints.standard;
    final stats = ref.watch(taskStatsProvider);

    return Scaffold(
      key: TaskBoardKeys.expandedLayout,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: layout.maxContentWidth),
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: TaskBoardHeader()),
                      ThemeModeButton(),
                    ],
                  ),
                  SizedBox(height: spacing.lg),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: _sidebarWidth,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AccentHeaderBand(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacing.md,
                                    vertical: spacing.sm,
                                  ),
                                  child: Text(
                                    AppStrings.createTask,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(spacing.md),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const TaskForm(showHeader: false),
                                          SizedBox(height: spacing.lg),
                                          Divider(
                                            color: theme
                                                .colorScheme
                                                .outlineVariant,
                                          ),
                                          SizedBox(height: spacing.lg),
                                          TaskStatsPanel(stats: stats),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: spacing.lg),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(spacing.md),
                              child: const TaskListSection(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
