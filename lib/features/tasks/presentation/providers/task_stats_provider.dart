import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/features/tasks/domain/models/task_stats.dart';
import 'package:task_management_app/features/tasks/presentation/controllers/task_controller.dart';

/// Derived task counts from the current task collection.
final taskStatsProvider = Provider<TaskStats>((ref) {
  final tasks = ref.watch(taskControllerProvider).value ?? const [];
  return TaskStats.fromTasks(tasks);
});
