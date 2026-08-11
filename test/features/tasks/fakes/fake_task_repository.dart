import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/domain/repositories/task_repository.dart';

class FakeTaskRepository implements TaskRepository {
  FakeTaskRepository([List<Task>? initialTasks])
    : _tasks = List<Task>.from(initialTasks ?? const []);

  final List<Task> _tasks;

  List<Task> get tasks => List<Task>.unmodifiable(_tasks);

  @override
  Future<List<Task>> getTasks() async {
    return List<Task>.unmodifiable(_tasks);
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((existing) => existing.id == task.id);
    if (index == -1) {
      throw StateError('Task not found: ${task.id}');
    }
    _tasks[index] = task;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == taskId);
    if (_tasks.length == initialLength) {
      throw StateError('Task not found: $taskId');
    }
  }
}
