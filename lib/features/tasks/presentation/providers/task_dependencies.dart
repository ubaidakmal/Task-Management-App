import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:task_management_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:task_management_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart';

/// Provides the modern async shared preferences client.
final sharedPreferencesAsyncProvider = Provider<SharedPreferencesAsync>((ref) {
  return SharedPreferencesAsync();
});

final taskLocalDataSourceProvider = Provider<TaskLocalDataSource>((ref) {
  return TaskLocalDataSource(
    preferences: ref.watch(sharedPreferencesAsyncProvider),
  );
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    localDataSource: ref.watch(taskLocalDataSourceProvider),
  );
});

/// Generates unique task identifiers. Override in tests for deterministic IDs.
final uuidProvider = Provider<String Function()>(
  (ref) =>
      () => const Uuid().v4(),
);
