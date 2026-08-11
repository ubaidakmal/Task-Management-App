import 'package:task_management_app/features/tasks/domain/models/task.dart';

/// Derived task counts for future summary UI.
class TaskStats {
  const TaskStats({
    required this.total,
    required this.active,
    required this.completed,
  });

  final int total;
  final int active;
  final int completed;

  factory TaskStats.fromTasks(List<Task> tasks) {
    final completedCount = tasks.where((task) => task.isCompleted).length;

    return TaskStats(
      total: tasks.length,
      active: tasks.length - completedCount,
      completed: completedCount,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TaskStats &&
            other.total == total &&
            other.active == active &&
            other.completed == completed;
  }

  @override
  int get hashCode => Object.hash(total, active, completed);
}
