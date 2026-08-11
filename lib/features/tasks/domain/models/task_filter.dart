import 'package:task_management_app/features/tasks/domain/models/task.dart';

/// Application-level task visibility filter. Not persisted.
enum TaskFilter { all, active, completed }

/// Applies [filter] to [tasks] without mutating the source list.
List<Task> applyTaskFilter(List<Task> tasks, TaskFilter filter) {
  return switch (filter) {
    TaskFilter.all => List<Task>.unmodifiable(tasks),
    TaskFilter.active =>
      tasks.where((task) => !task.isCompleted).toList(growable: false),
    TaskFilter.completed =>
      tasks.where((task) => task.isCompleted).toList(growable: false),
  };
}
