import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_dependencies.dart';
import '../../fakes/fake_task_repository.dart';

void main() {
  group('TaskController', () {
    late FakeTaskRepository fakeRepository;
    late ProviderContainer container;
    var generatedIds = <String>[];
    var nextId = 0;

    setUp(() {
      fakeRepository = FakeTaskRepository();
      generatedIds = [];
      nextId = 0;

      container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(fakeRepository),
          uuidProvider.overrideWithValue(() {
            final id = 'generated-id-${nextId++}';
            generatedIds.add(id);
            return id;
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<List<Task>> waitForInitialLoad() {
      return container.read(taskControllerProvider.future);
    }

    test(
      'loading an empty repository produces an empty task collection',
      () async {
        final tasks = await waitForInitialLoad();

        expect(tasks, isEmpty);
        expect(container.read(taskControllerProvider).isLoading, isFalse);
      },
    );

    test('loads existing repository tasks on initialization', () async {
      const existing = [
        Task(id: 'seed-1', title: 'Existing task'),
        Task(id: 'seed-2', title: 'Another task', isCompleted: true),
      ];
      fakeRepository = FakeTaskRepository(existing);

      container.dispose();
      container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(fakeRepository),
          uuidProvider.overrideWithValue(() => 'unused'),
        ],
      );

      final tasks = await waitForInitialLoad();

      expect(tasks, existing);
    });

    test(
      'adding a task trims title and note, starts incomplete, and persists',
      () async {
        await waitForInitialLoad();

        await container
            .read(taskControllerProvider.notifier)
            .addTask(
              title: '  Finish assessment  ',
              note: '  Complete layouts  ',
            );

        final tasks = container.read(taskControllerProvider).requireValue;

        expect(tasks, hasLength(1));
        expect(tasks.single.id, generatedIds.single);
        expect(tasks.single.title, 'Finish assessment');
        expect(tasks.single.note, 'Complete layouts');
        expect(tasks.single.isCompleted, isFalse);
        expect(fakeRepository.tasks, tasks);
      },
    );

    test('rejects empty or whitespace-only titles', () async {
      await waitForInitialLoad();

      expect(
        () => container
            .read(taskControllerProvider.notifier)
            .addTask(title: '   '),
        throwsA(isA<ArgumentError>()),
      );
      expect(fakeRepository.tasks, isEmpty);
      expect(container.read(taskControllerProvider).requireValue, isEmpty);
    });

    test('converts empty or whitespace-only notes to null', () async {
      await waitForInitialLoad();

      await container
          .read(taskControllerProvider.notifier)
          .addTask(title: 'Task title', note: '   ');

      final task = container.read(taskControllerProvider).requireValue.single;

      expect(task.note, isNull);
      expect(fakeRepository.tasks.single.note, isNull);
    });

    test('toggle flips completion state and persists', () async {
      fakeRepository = FakeTaskRepository([
        const Task(id: 'task-1', title: 'Toggle me'),
      ]);

      container.dispose();
      container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(fakeRepository),
          uuidProvider.overrideWithValue(() => 'unused'),
        ],
      );

      await waitForInitialLoad();

      await container
          .read(taskControllerProvider.notifier)
          .toggleTask('task-1');

      var task = container.read(taskControllerProvider).requireValue.single;
      expect(task.isCompleted, isTrue);
      expect(fakeRepository.tasks.single.isCompleted, isTrue);

      await container
          .read(taskControllerProvider.notifier)
          .toggleTask('task-1');

      task = container.read(taskControllerProvider).requireValue.single;
      expect(task.isCompleted, isFalse);
      expect(fakeRepository.tasks.single.isCompleted, isFalse);
    });

    test('delete removes the task and repository state matches', () async {
      fakeRepository = FakeTaskRepository([
        const Task(id: 'task-1', title: 'Keep'),
        const Task(id: 'task-2', title: 'Remove'),
      ]);

      container.dispose();
      container = ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(fakeRepository),
          uuidProvider.overrideWithValue(() => 'unused'),
        ],
      );

      await waitForInitialLoad();

      await container
          .read(taskControllerProvider.notifier)
          .deleteTask('task-2');

      final tasks = container.read(taskControllerProvider).requireValue;

      expect(tasks, hasLength(1));
      expect(tasks.single.id, 'task-1');
      expect(fakeRepository.tasks, hasLength(1));
      expect(fakeRepository.tasks.single.id, 'task-1');
    });
  });
}
