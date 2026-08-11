import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/responsive/responsive_layout.dart';
import 'package:task_management_app/features/tasks/presentation/layouts/compact_task_board_layout.dart';
import 'package:task_management_app/features/tasks/presentation/layouts/expanded_task_board_layout.dart';
import 'package:task_management_app/features/tasks/presentation/layouts/medium_task_board_layout.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';

/// Root task board screen that selects an adaptive layout by available width.
class TaskBoardScreen extends ConsumerWidget {
  const TaskBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return KeyedSubtree(
      key: TaskBoardKeys.screen,
      child: ResponsiveLayout(
        compact: const CompactTaskBoardLayout(),
        medium: const MediumTaskBoardLayout(),
        expanded: const ExpandedTaskBoardLayout(),
        large: const ExpandedTaskBoardLayout(),
      ),
    );
  }
}
