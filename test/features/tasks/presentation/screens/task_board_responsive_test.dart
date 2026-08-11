import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';
import '../../../../helpers/task_board_test_helpers.dart';
import '../../fakes/fake_task_repository.dart';

void main() {
  group('TaskBoardScreen responsive layouts', () {
    testWidgets('compact layout fits at 320px without overflow', (
      tester,
    ) async {
      final repository = FakeTaskRepository([
        const Task(id: '1', title: 'Active task'),
        const Task(
          id: '2',
          title:
              'Long title that should truncate cleanly on the narrowest phones',
          note: 'Extended note content for overflow verification on compact.',
          isCompleted: true,
        ),
      ]);

      await tester.setSurfaceSizeAndPump(
        const Size(320, 640),
        buildTaskBoardTestApp(repository: repository),
      );

      expect(find.byKey(TaskBoardKeys.compactLayout), findsOneWidget);
      expect(find.text('Task Board'), findsOneWidget);
      expect(find.byKey(const Key('theme_mode_button')), findsOneWidget);
      expect(find.text('Organize your work'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.byKey(TaskBoardKeys.addTaskFab), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('compact layout fits at 360px without overflow', (
      tester,
    ) async {
      final repository = FakeTaskRepository([
        const Task(id: '1', title: 'Sample task'),
      ]);

      await tester.setSurfaceSizeAndPump(
        const Size(360, 740),
        buildTaskBoardTestApp(repository: repository),
      );

      expect(find.byKey(TaskBoardKeys.compactLayout), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('compact layout fits at 430px without overflow', (
      tester,
    ) async {
      await tester.setSurfaceSizeAndPump(
        const Size(430, 844),
        buildTaskBoardTestApp(),
      );

      expect(find.byKey(TaskBoardKeys.compactLayout), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('add-task sheet remains usable with keyboard inset', (
      tester,
    ) async {
      await tester.setSurfaceSizeAndPump(
        const Size(390, 844),
        buildTaskBoardTestApp(),
      );

      await tester.tap(find.byKey(TaskBoardKeys.addTaskFab));
      await tester.pumpAndSettle();

      tester.view.viewInsets = const FakeViewPadding(bottom: 336);
      addTearDown(tester.view.reset);

      await tester.enterText(
        find.byType(TextFormField).first,
        'Keyboard visible title',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'Line one\nLine two\nLine three',
      );
      await tester.pumpAndSettle();

      expect(find.text('Keyboard visible title'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('expanded sidebar scrolls at short desktop height', (
      tester,
    ) async {
      await tester.setSurfaceSizeAndPump(
        const Size(1440, 520),
        buildTaskBoardTestApp(),
      );

      expect(find.byKey(TaskBoardKeys.expandedLayout), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsWidgets);
      expect(tester.takeException(), isNull);
    });

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
