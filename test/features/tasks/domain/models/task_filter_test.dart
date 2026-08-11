import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/domain/models/task_filter.dart';

void main() {
  final tasks = [
    const Task(id: '1', title: 'Active one'),
    const Task(id: '2', title: 'Completed one', isCompleted: true),
    const Task(id: '3', title: 'Active two'),
  ];

  group('applyTaskFilter', () {
    test('all filter returns all tasks', () {
      expect(applyTaskFilter(tasks, TaskFilter.all), tasks);
    });

    test('active filter returns only incomplete tasks', () {
      final filtered = applyTaskFilter(tasks, TaskFilter.active);

      expect(filtered, hasLength(2));
      expect(filtered.every((task) => !task.isCompleted), isTrue);
      expect(filtered.map((task) => task.id), ['1', '3']);
    });

    test('completed filter returns only completed tasks', () {
      final filtered = applyTaskFilter(tasks, TaskFilter.completed);

      expect(filtered, hasLength(1));
      expect(filtered.single.id, '2');
      expect(filtered.single.isCompleted, isTrue);
    });
  });
}
