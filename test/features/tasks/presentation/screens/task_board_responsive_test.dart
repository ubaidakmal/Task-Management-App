import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';
import '../../../../helpers/task_board_test_helpers.dart';
import '../../fakes/fake_task_repository.dart';

void main() {
  group('TaskBoardScreen responsive layouts', () {
    testWidgets('builds compact layout at phone width', (tester) async {
      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(),
      );

      expect(find.byKey(TaskBoardKeys.compactLayout), findsOneWidget);
      expect(find.byKey(TaskBoardKeys.mediumLayout), findsNothing);
      expect(find.byKey(TaskBoardKeys.expandedLayout), findsNothing);
      expect(find.text('Organize your work'), findsOneWidget);
    });

    testWidgets('builds medium layout at tablet width', (tester) async {
      await tester.setSurfaceSizeAndPump(
        const Size(768, 1024),
        buildTaskBoardTestApp(),
      );

      expect(find.byKey(TaskBoardKeys.mediumLayout), findsOneWidget);
      expect(find.byKey(TaskBoardKeys.compactLayout), findsNothing);
      expect(find.byKey(TaskBoardKeys.expandedLayout), findsNothing);
    });

    testWidgets('builds expanded layout at desktop width', (tester) async {
      await tester.setSurfaceSizeAndPump(
        const Size(1440, 900),
        buildTaskBoardTestApp(),
      );

      expect(find.byKey(TaskBoardKeys.expandedLayout), findsOneWidget);
      expect(find.byKey(TaskBoardKeys.compactLayout), findsNothing);
      expect(find.byKey(TaskBoardKeys.mediumLayout), findsNothing);
      expect(find.text('Create task'), findsOneWidget);
    });

    testWidgets('builds expanded layout at landscape tablet width', (
      tester,
    ) async {
      await tester.setSurfaceSizeAndPump(
        const Size(1024, 768),
        buildTaskBoardTestApp(),
      );

      expect(find.byKey(TaskBoardKeys.expandedLayout), findsOneWidget);
    });

    testWidgets('renders long task titles without layout exceptions', (
      tester,
    ) async {
      final repository = FakeTaskRepository([
        const Task(
          id: 'long-1',
          title:
              'This is an intentionally long task title that should wrap or '
              'truncate gracefully without causing RenderFlex overflow issues '
              'across adaptive layouts and text scaling scenarios',
          note:
              'Supporting note with additional detail that also needs to stay '
              'within card bounds without breaking the surrounding layout.',
        ),
      ]);

      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(repository: repository),
      );

      expect(
        find.textContaining('intentionally long task title'),
        findsOneWidget,
      );
    });

    testWidgets('renders empty state when there are no tasks', (tester) async {
      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(),
      );

      expect(find.byKey(TaskBoardKeys.taskEmptyState), findsOneWidget);
      expect(find.text('No tasks yet'), findsOneWidget);
    });
  });
}
