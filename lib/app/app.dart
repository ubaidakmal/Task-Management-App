import 'package:flutter/material.dart';

import 'package:task_management_app/app/theme/app_theme.dart';
import 'package:task_management_app/core/constants/app_constants.dart';
import 'package:task_management_app/features/tasks/presentation/screens/foundation_home_screen.dart';

/// Root application widget configured with Material 3 themes and Riverpod.
class TaskBoardApp extends StatelessWidget {
  const TaskBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const FoundationHomeScreen(),
    );
  }
}
