import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_management_app/app/app.dart';

/// Pumps [TaskBoardApp] wrapped in [ProviderScope] for widget tests.
extension PumpApp on WidgetTester {
  Future<void> pumpTaskBoardApp() {
    return pumpWidget(const ProviderScope(child: TaskBoardApp()));
  }
}
