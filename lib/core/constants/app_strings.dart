/// Centralized user-facing strings for the application.
abstract final class AppStrings {
  // ── App identity ──────────────────────────────────────────────────────────
  static const String appName = 'Task Board';
  static const String tagline = 'Organize your work';

  // ── Task board ──────────────────────────────────────────────────────────────
  static const String taskBoardTitle = 'Task Board';
  static const String tasksSection = 'Tasks';
  static const String createTask = 'Create task';
  static const String addTask = 'Add task';

  // ── Task form ───────────────────────────────────────────────────────────────
  static const String titleLabel = 'Title';
  static const String titleHint = 'What needs to be done?';
  static const String titleRequired = 'Title is required';
  static const String titleEmptyError = 'Title cannot be empty.';
  static const String noteLabel = 'Note (optional)';
  static const String noteHint = 'Add details if needed';
  static const String invalidTitleMessage = 'Please enter a valid title.';

  // ── Filters ─────────────────────────────────────────────────────────────────
  static const String filterAll = 'All';
  static const String filterActive = 'Active';
  static const String filterCompleted = 'Completed';

  // ── Statistics ──────────────────────────────────────────────────────────────
  static const String overview = 'Overview';
  static const String statTotal = 'Total';
  static const String statActive = 'Active';
  static const String statCompleted = 'Completed';

  static String compactStatsSummary(int active, int completed) {
    return '$active active · $completed completed';
  }

  // ── Empty states ────────────────────────────────────────────────────────────
  static const String emptyNoTasksTitle = 'No tasks yet';
  static const String emptyNoTasksBody = 'Add your first task to get started.';
  static const String emptyNoActiveTitle = 'No active tasks';
  static const String emptyNoActiveBody = 'Everything is complete for now.';
  static const String emptyNoCompletedTitle = 'No completed tasks yet';
  static const String emptyNoCompletedBody =
      'Completed tasks will appear here.';

  // ── Loading & errors ────────────────────────────────────────────────────────
  static const String errorLoadTasksTitle = 'Could not load tasks';
  static const String errorLoadTasksBody =
      'Your saved tasks could not be read. Try again.';
  static const String errorAddTask = 'Could not add task. Please try again.';
  static const String errorUpdateTask =
      'Could not update task. Please try again.';
  static const String errorDeleteTask =
      'Could not delete task. Please try again.';
  static const String retry = 'Retry';

  // ── Actions & tooltips ──────────────────────────────────────────────────────
  static const String deleteTaskTooltip = 'Delete task';

  // ── Appearance / theme ────────────────────────────────────────────────────
  static const String appearance = 'Appearance';
  static const String appearanceSubtitle = 'Choose how Task Board looks';
  static const String themeLight = 'Light';
  static const String themeLightDescription = 'Bright, clean workspace';
  static const String themeDark = 'Dark';
  static const String themeDarkDescription = 'Comfortable in low light';
  static const String themeSystem = 'System';
  static const String themeSystemDescription = 'Follow device settings';
}
