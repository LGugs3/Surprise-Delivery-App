// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:surpirse_delivery_app/pages/signin_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

//firebase doesn't like being used for testing so can't use sign in until i learn a lot more about mockito
void main() {
  //for future tests
  final mockObserver = MockNavigatorObserver();
  //sign-in widgets
  Finder emailInput = find.byKey(Key("Email Input"));
  Finder passInput = find.byKey(Key("Password Input"));
  Finder submitButton = find.byKey(Key("Login Submit"));

  group("Login Page", (){
    testWidgets('Verify Widgets Exist', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(
            home: const SignInPage(),
            navigatorObservers: [mockObserver],
          )
      );

      //confirm widgets exist
      expect(emailInput, findsOneWidget);
      expect(passInput, findsOneWidget);
      expect(submitButton, findsOneWidget);
    });

    testWidgets("Text can be entered into fields", (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(
            home: const SignInPage(),
            navigatorObservers: [mockObserver],
          )
      );
      //set username
      String usernameStr = "testuser@gmail.com";
      await tester.enterText(emailInput, usernameStr);

      //set password
      String? passStr = "testPass";
      await tester.enterText(passInput, passStr);

      //press button and wait until no more frames to show
      expect(find.text(usernameStr), findsOneWidget);
      expect(find.text(passStr), findsOneWidget);
    });
  });

  // Tap the '+' icon and trigger a frame.
  //await tester.tap(find.byIcon(Icons.add));
  //await tester.pump();

  // Verify that our counter has incremented.
  //expect(find.text('0'), findsNothing);
  //expect(find.text('1'), findsOneWidget);
}
