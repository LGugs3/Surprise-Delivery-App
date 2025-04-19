import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
import 'package:surpirse_delivery_app/pages/order_form.dart';
import 'package:surpirse_delivery_app/pages/second_orderformpage.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';
import 'package:surpirse_delivery_app/reusable_widgets/order_data_class.dart';
import 'finder_widgets.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class FakeRoute extends Fake implements Route {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  group("Navigations", () {
    testWidgets("Nav to Base Map", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(),
          navigatorObservers: [mockObserver],
        ),
      );

      expect(viewMapButton, findsOneWidget);
      tester.ensureVisible(viewMapButton);
      await tester.tap(viewMapButton);
      await tester.pump();
      await tester.pump(settleTime);

      verify(() => mockObserver.didPush(any(), any()));
      expect(mapState, findsOneWidget);

    });

    testWidgets("Nav to Settings", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(),
          navigatorObservers: [mockObserver],
        ),
      );


      expect(settingsButton, findsOneWidget);

      tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pump();
      await tester.pump(settleTime);

      verify(() => mockObserver.didPush(any(), any()));
      expect(settingsState, findsOneWidget);
    });

    testWidgets("Navigate to Reset Password from Settings", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: SettingsPage(),
          navigatorObservers: [mockObserver],
        ),
      );

      tester.ensureVisible(resetPassSettingsButton);
      await tester.tap(resetPassSettingsButton);
      await tester.pump();
      await tester.pump(settleTime);

      verify(() => mockObserver.didPush(any(), any()));
      expect(resetPasswordState, findsOneWidget);
    });

    testWidgets("Nav to Order Form", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(),
          navigatorObservers: [mockObserver],
        ),
      );

      tester.ensureVisible(placeOrderButton);
      await tester.tap(placeOrderButton);
      await tester.pump();
      await tester.pump(settleTime);

      verify(() => mockObserver.didPush(any(), any()));
      expect(orderState, findsOneWidget);
    });

    testWidgets("Nav to second order from from first order form", (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: OrderForm(),
          navigatorObservers: [mockObserver],
        ),
      );

      //add meal before submitting
      Finder incMainMeal = getMealContainerAcc("main", true);
      tester.ensureVisible(incMainMeal);
      await tester.tap(incMainMeal);
      await tester.pump();

      expect(continueOrderButton, findsOneWidget);
      tester.ensureVisible(continueOrderButton);
      await tester.tap(continueOrderButton);
      await tester.pump();
      await tester.pump(settleTime);

      verify(() => mockObserver.didPush(any(), any()));
      expect(secondOrderState, findsOneWidget);
    });

    testWidgets("Nav to Payment from second order form", (WidgetTester tester) async {
      final OrderData orderData = OrderData.empty();
      orderData.randomizeOrder();

      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          home: SecondOrderPage(orderData: orderData,),
          navigatorObservers: [mockObserver],
        ),
      );

      //second order form must be completed before continuing
      await fillSecondOrderForm(tester);

      expect(continuePaymentButton, findsOneWidget);
      tester.ensureVisible(continuePaymentButton);
      await tester.tap(continuePaymentButton);
      await tester.pump();
      await tester.pump(settleTime);

      verify(() => mockObserver.didPush(any(), any()));
      expect(paymentState, findsOneWidget);
    });

  });
  //navigate to pages in settings page
}