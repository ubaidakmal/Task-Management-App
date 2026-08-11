import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/features/tasks/domain/models/task_filter.dart';

final taskFilterProvider = NotifierProvider<TaskFilterNotifier, TaskFilter>(
  TaskFilterNotifier.new,
);

class TaskFilterNotifier extends Notifier<TaskFilter> {
  @override
  TaskFilter build() => TaskFilter.all;

  void setFilter(TaskFilter filter) {
    state = filter;
  }
}
