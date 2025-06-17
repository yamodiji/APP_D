import 'package:flutter_test/flutter_test.dart';
import 'package:appsearch/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads without throwing any exceptions
    expect(find.byType(MyApp), findsOneWidget);
  });
} 