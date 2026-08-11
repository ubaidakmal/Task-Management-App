import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_management_app/app/theme/app_theme.dart';
import 'package:task_management_app/app/theme/theme_mode_provider.dart';
import 'package:task_management_app/core/constants/app_constants.dart';
import 'package:task_management_app/features/tasks/presentation/screens/splash_screen.dart';

/// Root application widget configured with Material 3 themes and Riverpod.
class TaskBoardApp extends ConsumerWidget {
  const TaskBoardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
