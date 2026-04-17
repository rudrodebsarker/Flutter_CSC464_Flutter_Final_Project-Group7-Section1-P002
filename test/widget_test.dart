import 'package:flutter_test/flutter_test.dart';

import 'package:tictactoe_p002/main.dart';

void main() {
  testWidgets('App widget mounts', (WidgetTester tester) async {
    await tester.pumpWidget(const RadiantToeApp());
    expect(find.byType(RadiantToeApp), findsOneWidget);
  });
}
