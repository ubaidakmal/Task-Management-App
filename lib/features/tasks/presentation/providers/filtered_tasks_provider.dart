import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/domain/models/task_filter.dart';
import 'package:task_management_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_filter_provider.dart';

/// Tasks visible for the currently selected [TaskFilter].
final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasksAsync = ref.watch(taskControllerProvider);
  final filter = ref.watch(taskFilterProvider);

  return tasksAsync.maybeWhen(
    data: (tasks) => applyTaskFilter(tasks, filter),
    orElse: () => const [],
  );
});
