import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_dependencies.dart';

final taskControllerProvider =
    AsyncNotifierProvider<TaskController, List<Task>>(TaskController.new);

class TaskController extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() {
    return ref.read(taskRepositoryProvider).getTasks();
  }

  Future<void> addTask({required String title, String? note}) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw ArgumentError.value(title, 'title', AppStrings.titleEmptyError);
    }

    final normalizedNote = _normalizeNote(note);
    final task = Task(
      id: ref.read(uuidProvider)(),
      title: trimmedTitle,
      note: normalizedNote,
    );

    final currentTasks = state.requireValue;
    await ref.read(taskRepositoryProvider).addTask(task);
    state = AsyncData([...currentTasks, task]);
  }

  Future<void> toggleTask(String taskId) async {
    final currentTasks = state.requireValue;
    final index = currentTasks.indexWhere((task) => task.id == taskId);
    if (index == -1) {
      throw StateError('Task not found: $taskId');
    }

    final updatedTask = currentTasks[index].copyWith(
      isCompleted: !currentTasks[index].isCompleted,
    );
    final updatedTasks = [...currentTasks]..[index] = updatedTask;

    await ref.read(taskRepositoryProvider).updateTask(updatedTask);
    state = AsyncData(updatedTasks);
  }

  Future<void> deleteTask(String taskId) async {
    final currentTasks = state.requireValue;
    final updatedTasks = currentTasks
        .where((task) => task.id != taskId)
        .toList(growable: false);

    if (updatedTasks.length == currentTasks.length) {
      throw StateError('Task not found: $taskId');
    }

    await ref.read(taskRepositoryProvider).deleteTask(taskId);
    state = AsyncData(updatedTasks);
  }

  /// Reloads tasks from persistence, replacing the current async state.
  Future<void> reloadTasks() async {
    state = const AsyncLoading<List<Task>>();
    state = await AsyncValue.guard(
      () => ref.read(taskRepositoryProvider).getTasks(),
    );
  }

  String? _normalizeNote(String? note) {
    if (note == null) {
      return null;
    }

    final trimmed = note.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
