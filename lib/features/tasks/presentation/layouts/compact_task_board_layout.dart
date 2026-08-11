import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/theme/app_colors.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/app/widgets/accent_header_band.dart';
import 'package:task_management_app/app/widgets/brand_logo.dart';
import 'package:task_management_app/app/widgets/theme_mode_button.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_stats_provider.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_list_section.dart';

/// Touch-first phone layout with FAB and bottom-sheet task creation.
class CompactTaskBoardLayout extends ConsumerWidget {
  const CompactTaskBoardLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;
    final stats = ref.watch(taskStatsProvider);

    return Scaffold(
      key: TaskBoardKeys.compactLayout,
      appBar: AppBar(
        title: const Text(AppStrings.taskBoardTitle),
        actions: const [
          ThemeModeButton(),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: BrandLogo(size: 32),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: TaskBoardKeys.addTaskFab,
        onPressed: () => showCompactAddTaskSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.addTask),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.md,
            spacing.sm,
            spacing.md,
            spacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccentHeaderBand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tagline,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightSurface,
                      ),
                    ),
                    if (stats.total > 0) ...[
                      SizedBox(height: spacing.xxs),
                      Text(
                        AppStrings.compactStatsSummary(
                          stats.active,
                          stats.completed,
                        ),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: spacing.md),
              const Expanded(
                child: TaskListSection(
                  showSectionHeader: false,
                  listBottomPadding: 88,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
