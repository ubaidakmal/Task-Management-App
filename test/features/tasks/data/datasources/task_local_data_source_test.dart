import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:task_management_app/features/tasks/data/constants/task_storage_keys.dart';
import 'package:task_management_app/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';

void main() {
  group('TaskLocalDataSource', () {
    late TaskLocalDataSource dataSource;

    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      dataSource = TaskLocalDataSource(preferences: SharedPreferencesAsync());
    });

    tearDown(() {
      SharedPreferencesAsyncPlatform.instance = null;
    });

    test('returns empty list on first launch', () async {
      expect(await dataSource.readTasks(), isEmpty);
    });

    test('persists and reloads tasks as JSON', () async {
      const tasks = [
        Task(
          id: 'task-1',
          title: 'Finish assessment',
          note: 'Complete responsive layouts',
        ),
        Task(id: 'task-2', title: 'Completed task', isCompleted: true),
      ];

      await dataSource.writeTasks(tasks);

      expect(await dataSource.readTasks(), tasks);
    });

    test('returns empty list for malformed JSON instead of crashing', () async {
      final preferences = SharedPreferencesAsync();
      await preferences.setString(TaskStorageKeys.tasks, '{not-valid-json');

      final corruptedSource = TaskLocalDataSource(preferences: preferences);

      expect(await corruptedSource.readTasks(), isEmpty);
    });

    test('returns empty list when stored JSON is not a list', () async {
      final preferences = SharedPreferencesAsync();
      await preferences.setString(TaskStorageKeys.tasks, '{"id":"1"}');

      final corruptedSource = TaskLocalDataSource(preferences: preferences);

      expect(await corruptedSource.readTasks(), isEmpty);
    });
  });
}
