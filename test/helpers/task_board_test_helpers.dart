import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/app/app.dart';
import 'package:task_management_app/app/theme/app_theme.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';
import 'package:task_management_app/features/tasks/presentation/providers/task_dependencies.dart';
import 'package:task_management_app/features/tasks/presentation/screens/task_board_screen.dart';
import '../features/tasks/fakes/fake_task_repository.dart';

/// Builds the full [TaskBoardApp] with fake dependencies for widget tests.
Widget buildTaskBoardApp({
  FakeTaskRepository? repository,
  String Function()? uuid,
}) {
  var idCounter = 0;

  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWithValue(
        repository ?? FakeTaskRepository(),
      ),
      uuidProvider.overrideWithValue(uuid ?? () => 'test-task-${idCounter++}'),
    ],
    child: const TaskBoardApp(),
  );
}

/// Builds [TaskBoardScreen] with a fake repository for widget tests.
Widget buildTaskBoardTestApp({
  FakeTaskRepository? repository,
  String Function()? uuid,
  ThemeMode themeMode = ThemeMode.light,
}) {
  var idCounter = 0;

  return ProviderScope(
    overrides: [
      taskRepositoryProvider.overrideWithValue(
        repository ?? FakeTaskRepository(),
      ),
      uuidProvider.overrideWithValue(uuid ?? () => 'test-task-${idCounter++}'),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const TaskBoardScreen(),
    ),
  );
}

extension TaskBoardTester on WidgetTester {
  Future<void> setSurfaceSizeAndPump(
    Size size,
    Widget app, {
    bool settle = true,
  }) async {
    await binding.setSurfaceSize(size);
    addTearDown(() => binding.setSurfaceSize(null));
    await pumpWidget(app);
    if (settle) {
      await pumpAndSettle();
    } else {
      await pump();
    }
  }
}

Task seedTask({
  required String id,
  required String title,
  String? note,
  bool isCompleted = false,
}) {
  return Task(id: id, title: title, note: note, isCompleted: isCompleted);
}
