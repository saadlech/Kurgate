// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';

import 'package:kurgate/main.dart';

void main() {
  testWidgets('App renders onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const KurgateApp());

    // Verify that onboarding screen renders with the brand name
    expect(find.text('kurgate.'), findsOneWidget);
    expect(find.text('Discover Morocco'), findsOneWidget);
  });
}
