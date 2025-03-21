import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
import 'package:surpirse_delivery_app/pages/signin_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  //sign-in widgets
  Finder emailInput = find.byKey(Key("Email Input"));
  Finder passInput = find.byKey(Key("Password Input"));
  Finder submitButton = find.byKey(Key("Login Submit"));

  //home page widgets
  Finder viewMapButton = find.byKey(Key("View Map"));
  Finder placeOrderButton = find.byKey(Key("home-page-order"));
  Finder settingsButton = find.byKey(Key("Settings Button"));
  Finder homeLogoutButton = find.byKey(Key("home-logout-button"));

  group("Login Page", (){
    testWidgets('Verify Widgets Exist', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
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
      final mockObserver = MockNavigatorObserver();
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

  group("Home Page", () {
    testWidgets("Verify Widgets Exist", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
          MaterialApp(
            home: const HomePage(),
            navigatorObservers: [mockObserver],
          )
      );
      expect(viewMapButton, findsOneWidget);
      expect(placeOrderButton, findsOneWidget);
      expect(settingsButton, findsOneWidget);
      expect(homeLogoutButton, findsOneWidget);
    });

    testWidgets("Press View Map Button", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
          MaterialApp(
            home: const HomePage(),
            navigatorObservers: [mockObserver],
          )
      );

      tester.ensureVisible(viewMapButton);
      await tester.tap(viewMapButton);
      await tester.pumpAndSettle();

      expect(find.byType(BaseMap), findsOneWidget);
    });
  });

  group("Settings Page", () {
    //reset password
    //second order page
    //update preferences
  });
}