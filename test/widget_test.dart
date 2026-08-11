import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_management_app/app/app.dart';
import 'package:task_management_app/core/constants/app_constants.dart';

void main() {
  testWidgets('Foundation shell renders with app title and status cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TaskBoardApp()));
    await tester.pumpAndSettle();

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text('Foundation ready'), findsOneWidget);
    expect(find.textContaining('Active layout tier'), findsOneWidget);
    expect(find.textContaining('Theme mode'), findsOneWidget);
  });
}
