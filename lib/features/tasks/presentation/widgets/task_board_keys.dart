import 'package:flutter/material.dart';

/// Stable keys for task board widget and integration tests.
abstract final class TaskBoardKeys {
  static const screen = Key('task_board_screen');
  static const compactLayout = Key('compact_task_board_layout');
  static const mediumLayout = Key('medium_task_board_layout');
  static const expandedLayout = Key('expanded_task_board_layout');
  static const taskForm = Key('task_form');
  static const taskFilterControl = Key('task_filter_control');
  static const taskEmptyState = Key('task_empty_state');
  static const taskList = Key('task_list');
  static const addTaskFab = Key('add_task_fab');
  static const addTaskDialog = Key('add_task_dialog');
}
