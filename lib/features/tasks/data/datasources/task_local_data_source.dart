import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/features/tasks/data/constants/task_storage_keys.dart';
import 'package:task_management_app/features/tasks/domain/models/task.dart';

/// Reads and writes the full task collection as JSON via [SharedPreferencesAsync].
class TaskLocalDataSource {
  TaskLocalDataSource({required SharedPreferencesAsync preferences})
    : _preferences = preferences;

  final SharedPreferencesAsync _preferences;

  /// Loads persisted tasks.
  ///
  /// Returns an empty list when no data exists. Malformed stored JSON is treated
  /// as recoverable corruption: the method returns an empty list rather than
  /// crashing the app.
  Future<List<Task>> readTasks() async {
    final jsonString = await _preferences.getString(TaskStorageKeys.tasks);
    if (jsonString == null || jsonString.isEmpty) {
      return const [];
    }

    return _parseStoredTasks(jsonString);
  }

  /// Parses stored JSON into tasks.
  ///
  /// Only decoding and data-shape failures are treated as recoverable corruption.
  /// SharedPreferences read failures propagate to the caller.
  List<Task> _parseStoredTasks(String jsonString) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } on FormatException {
      return const [];
    }

    if (decoded is! List) {
      return const [];
    }

    final tasks = <Task>[];
    for (final entry in decoded) {
      if (entry is! Map) {
        continue;
      }

      try {
        tasks.add(Task.fromJson(Map<String, dynamic>.from(entry)));
      } on TypeError {
        continue;
      }
    }

    return List<Task>.unmodifiable(tasks);
  }

  Future<void> writeTasks(List<Task> tasks) async {
    final encoded = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await _preferences.setString(TaskStorageKeys.tasks, encoded);
  }
}
