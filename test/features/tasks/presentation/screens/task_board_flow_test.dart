import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';
import '../../../../helpers/task_board_test_helpers.dart';
import '../../fakes/fake_task_repository.dart';

void main() {
  group('TaskBoardScreen flows', () {
    testWidgets('adds a task through compact bottom sheet UI', (tester) async {
      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(),
      );

      await tester.tap(find.byKey(TaskBoardKeys.addTaskFab));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Finish responsive UI',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Step 3 complete',
      );
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Finish responsive UI'), findsOneWidget);
      expect(find.text('Step 3 complete'), findsOneWidget);
      expect(find.byKey(TaskBoardKeys.taskEmptyState), findsNothing);
      expect(find.text('All'), findsWidgets);
    });

    testWidgets('switches filter from Completed to All after adding a task', (
      tester,
    ) async {
      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(),
      );

      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(TaskBoardKeys.addTaskFab));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).first,
        'Visible after add',
      );
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Visible after add'), findsOneWidget);
      expect(find.text('All'), findsWidgets);
      expect(find.text('Completed'), findsWidgets);
    });

    testWidgets('switches Active and Completed filters', (tester) async {
      final repository = FakeTaskRepository([
        const Task(id: '1', title: 'Active task'),
        const Task(id: '2', title: 'Done task', isCompleted: true),
      ]);

      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(repository: repository),
      );

      await tester.tap(find.text('Active'));
      await tester.pumpAndSettle();
      expect(find.text('Active task'), findsOneWidget);
      expect(find.text('Done task'), findsNothing);

      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();
      expect(find.text('Done task'), findsOneWidget);
      expect(find.text('Active task'), findsNothing);
    });

    testWidgets('toggles a task from the UI', (tester) async {
      final repository = FakeTaskRepository([
        const Task(id: '1', title: 'Toggle me'),
      ]);

      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(repository: repository),
      );

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(repository.tasks.single.isCompleted, isTrue);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('deletes a task from the UI', (tester) async {
      final repository = FakeTaskRepository([
        const Task(id: '1', title: 'Delete me'),
        const Task(id: '2', title: 'Keep me'),
      ]);

      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(repository: repository),
      );

      final deleteButtons = find.byIcon(Icons.delete_outline_rounded);
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.deleteTaskDialogTitle), findsOneWidget);
      await tester.tap(find.text(AppStrings.deleteConfirm));
      await tester.pumpAndSettle();

      expect(find.text('Delete me'), findsNothing);
      expect(find.text('Keep me'), findsOneWidget);
      expect(repository.tasks, hasLength(1));
    });

    testWidgets('adds a task through desktop persistent form', (tester) async {
      await tester.setSurfaceSizeAndPump(
        const Size(1440, 900),
        buildTaskBoardTestApp(),
      );

      final titleFields = find.byType(TextFormField);
      await tester.enterText(titleFields.first, 'Desktop task');
      await tester.tap(find.text('Add task').last);
      await tester.pumpAndSettle();

      expect(find.text('Desktop task'), findsOneWidget);
    });
  });
}
