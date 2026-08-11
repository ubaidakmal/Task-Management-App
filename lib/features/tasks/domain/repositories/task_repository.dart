import 'package:task_management_app/features/tasks/domain/models/task.dart';

/// Persistence contract hidden from UI and Riverpod presentation code.
abstract interface class TaskRepository {
  Future<List<Task>> getTasks();

  Future<void> addTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String taskId);
}
