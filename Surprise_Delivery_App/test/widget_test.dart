// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'standardTest.dart' as std_test;
import 'navigation.dart' as nav_test;

//firebase doesn't like being used for testing so can't use sign in until i learn a lot more about mockito
void main() {
  std_test.main();
  nav_test.main();
  // Tap the '+' icon and trigger a frame.
  //tester.ensureVisible(finder);
  //await tester.tap(find.byIcon(Icons.add));
  //await tester.pumpAndSettle();

  // Verify that our counter has incremented.
  //expect(find.text('0'), findsNothing);
  //expect(find.text('1'), findsOneWidget);
}
