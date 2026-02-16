import 'package:flutter_test/flutter_test.dart';
import 'package:food_ninja/splashscreen.dart';

void main() {
  testWidgets('Splash renders app brand', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Food Ninja'), findsOneWidget);
  });
}
