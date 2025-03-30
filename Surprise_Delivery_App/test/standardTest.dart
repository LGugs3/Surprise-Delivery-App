import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
import 'package:surpirse_delivery_app/pages/order_form.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';
import 'package:surpirse_delivery_app/pages/signin_page.dart';
import 'finder_widgets.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("Login Page", (){
    //test sign up and forgot password
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

  group("Order Form", () {
    testWidgets("Verify Widgets Exist", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
          MaterialApp(
            home: const OrderForm(),
            navigatorObservers: [mockObserver],
          )
      );

      //Containers
      expect(find.text("Help Us Pick!"), findsExactly(2));
      expect(addMealButton, findsOneWidget);
      expect(mealContainer, findsOneWidget);

      //Widgets inside container
      for (final entree in entreeTypes)
        {
          expect(getMealContainerAcc(entree, true), findsOneWidget);
          expect(getMealContainerAcc(entree, false), findsOneWidget);
          expect(getMealContainerCount(entree), findsOneWidget);
        }
    });

    testWidgets("Add More Meals", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
          MaterialApp(
            home: const OrderForm(),
            navigatorObservers: [mockObserver],
          )
      );

      //add another meal
      tester.ensureVisible(addMealButton);
      await tester.tap(addMealButton);
      await tester.pump();

      //check for new meal container
      expect(mealContainer, findsExactly(2));
    });

    testWidgets("Add Different Entree Counts", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
          MaterialApp(
            home: const OrderForm(),
            navigatorObservers: [mockObserver],
          )
      );

      for (final entree in entreeTypes)
      {
        Finder entreeInc = getMealContainerAcc(entree, true);
        Finder entreeDec = getMealContainerAcc(entree, false);
        Finder entreeCount = getMealContainerCount(entree);
        Text counterWidget;

        int incRng = Random().nextInt(11);
        int decRng = Random().nextInt(11);

        tester.ensureVisible(entreeInc);
        //increment random number of times
        for (int acc = 0; acc < incRng; acc++)
        {
          await tester.tap(entreeInc);
          await tester.pump();
        }
        counterWidget = entreeCount.evaluate().single.widget as Text;
        expect(counterWidget.data, incRng.toString());

        //dec random number of times
        tester.ensureVisible(entreeDec);
        for (int acc = 0; acc < decRng; acc++)
        {
          await tester.tap(entreeDec);
          await tester.pump();
        }
        counterWidget = entreeCount.evaluate().single.widget as Text;
        expect(counterWidget.data, (incRng - decRng).clamp(0, 10).toString());
      }
    });
  });

  group("Settings Page", () {
    testWidgets("Verify Widgets Exist", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
          MaterialApp(
            home: const SettingsPage(),
            navigatorObservers: [mockObserver],
          )
      );

      expect(updatePreferencesButton, findsOneWidget);
      expect(resetPassSettingsButton, findsOneWidget);
      expect(secondOrderFormButton, findsOneWidget);
    });
  });

  //cannot do second order page until fix render issue
}