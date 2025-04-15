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
  nav_test.main();
  std_test.main();
}
