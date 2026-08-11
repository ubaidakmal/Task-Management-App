import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';

void main() {
  group('Task', () {
    const task = Task(
      id: 'task-1',
      title: 'Finish assessment',
      note: 'Complete responsive layouts',
      isCompleted: false,
    );

    test('JSON round-trip preserves all fields', () {
      final restored = Task.fromJson(task.toJson());

      expect(restored, task);
      expect(restored.id, 'task-1');
      expect(restored.title, 'Finish assessment');
      expect(restored.note, 'Complete responsive layouts');
      expect(restored.isCompleted, isFalse);
    });

    test('null note round-trips correctly', () {
      const taskWithoutNote = Task(id: 'task-2', title: 'Ship foundation');

      final restored = Task.fromJson(taskWithoutNote.toJson());

      expect(restored.note, isNull);
      expect(restored, taskWithoutNote);
    });

    test('copyWith updates selected fields', () {
      final updated = task.copyWith(isCompleted: true, title: 'Updated title');

      expect(updated.id, task.id);
      expect(updated.title, 'Updated title');
      expect(updated.note, task.note);
      expect(updated.isCompleted, isTrue);
    });
  });
}
