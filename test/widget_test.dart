import 'package:flutter_test/flutter_test.dart';

import 'helpers/task_board_test_helpers.dart';

void main() {
  testWidgets('Task board app renders at launch', (WidgetTester tester) async {
    await tester.pumpWidget(buildTaskBoardTestApp());
    await tester.pumpAndSettle();

    expect(find.text('Organize your work'), findsWidgets);
  });
}
