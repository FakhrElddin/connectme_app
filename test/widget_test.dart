import 'package:connectme_app/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginScreen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify key UI elements render
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('FORGOT PASSWORD'), findsOneWidget);
    expect(find.text('LOG IN'), findsOneWidget);
    expect(find.text('or LOG IN by'), findsOneWidget);
    expect(find.textContaining('SIGN UP'), findsOneWidget);
  });
}
