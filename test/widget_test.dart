import 'package:flutter_test/flutter_test.dart';

import 'package:prettypie_myai/main.dart';

void main() {
  testWidgets('Login page toggle switches to manual login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('MyDigital ID'), findsOneWidget);
    expect(find.text('Manual Login'), findsOneWidget);
    expect(find.textContaining('Send OTP'), findsOneWidget);

    await tester.tap(find.text('Manual Login'));
    await tester.pumpAndSettle();

    expect(find.text('IC Number / Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.textContaining('Sign In'), findsOneWidget);
  });
}
