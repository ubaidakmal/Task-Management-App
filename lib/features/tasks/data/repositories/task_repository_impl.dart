import 'package:task_management_app/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required TaskLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final TaskLocalDataSource _localDataSource;

  @override
  Future<List<Task>> getTasks() {
    return _localDataSource.readTasks();
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = [...await _localDataSource.readTasks(), task];
    await _localDataSource.writeTasks(tasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await _localDataSource.readTasks();
    final index = tasks.indexWhere((existing) => existing.id == task.id);
    if (index == -1) {
      throw StateError('Task not found: ${task.id}');
    }

    final updatedTasks = [...tasks]..[index] = task;
    await _localDataSource.writeTasks(updatedTasks);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final tasks = await _localDataSource.readTasks();
    final initialLength = tasks.length;
    final updatedTasks = tasks.where((task) => task.id != taskId).toList();

    if (updatedTasks.length == initialLength) {
      throw StateError('Task not found: $taskId');
    }

    await _localDataSource.writeTasks(updatedTasks);
  }
}
