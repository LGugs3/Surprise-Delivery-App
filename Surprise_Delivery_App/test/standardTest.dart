import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
import 'package:surpirse_delivery_app/pages/order_form.dart';
import 'package:surpirse_delivery_app/pages/payment_page.dart';
import 'package:surpirse_delivery_app/pages/second_orderformpage.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';
import 'package:surpirse_delivery_app/pages/signin_page.dart';
import 'package:surpirse_delivery_app/reusable_widgets/order_data_class.dart';
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
      await tester.pumpWidget(
        MaterialApp(
          home: HomePage(),
        ),
      );
      expect(viewMapButton, findsOneWidget);
      expect(placeOrderButton, findsOneWidget);
      expect(settingsButton, findsOneWidget);
      expect(homeLogoutButton, findsOneWidget);
      expect(homeFortuneWheel, findsOneWidget);
      expect(homeWheelButton, findsOneWidget);
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
      await tester.pump();
      await tester.pump(settleTime);

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
      expect(continueOrderButton, findsOneWidget);

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

  group("Second Order Form", () {
    testWidgets("Verify Widgets Exist", (WidgetTester tester) async {
      final OrderData orderData = OrderData.empty();
      orderData.randomizeOrder();

      await tester.pumpWidget(MaterialApp(
        home: SecondOrderPage(orderData: orderData,),
      ));

      expect(cuisineTypeText, findsOneWidget);
      expect(cuisineDropdownSecondForm, findsOneWidget);
      expect(addressTextSecondForm, findsOneWidget);
      expect(addressInputSecondForm, findsOneWidget);
      expect(cityInputSecondForm, findsOneWidget);
      expect(stateTextSecondForm, findsOneWidget);
      expect(stateInputSecondForm, findsOneWidget);
      expect(zipTextSecondForm, findsOneWidget);
      expect(zipInputSecondForm, findsOneWidget);
    });

    testWidgets("Fill Form", (WidgetTester tester) async {
      final OrderData orderData = OrderData.empty();
      orderData.randomizeOrder();

      await tester.pumpWidget(MaterialApp(
        home: SecondOrderPage(orderData: orderData,),
      ));

      int rng = Random().nextInt(cuisineTypes.length);
      await fillSecondOrderForm(tester, rng);

      //find inputted text
      for(String field in secondOrderFormInputFields.values)
      {
        expect(find.text(field), findsOneWidget);
      }
    });
  });

  group("Payment Page", () {
    testWidgets("Verify Widgets Exist", (WidgetTester tester) async {
      final OrderData orderData = OrderData.empty();
      orderData.randomizeOrder();

      await tester.pumpWidget(MaterialApp(
        home: Payment(orderData: orderData,),
      ));

      expect(payAmountTextPayForm, findsOneWidget);
      expect(payAmountSliderPayForm, findsOneWidget);
      expect(credCardTextPayForm, findsOneWidget);
      expect(expDateTextPayForm, findsOneWidget);
      expect(expDateInputPayForm, findsOneWidget);
      expect(secCodeTextPayForm, findsOneWidget);
      expect(secCodeInputPayForm, findsOneWidget);
      expect(countryTextPayForm, findsOneWidget);
      expect(countryInputPayForm, findsOneWidget);
      expect(zipTextPayForm, findsOneWidget);
      expect(zipInputPayForm, findsOneWidget);
      expect(completeOrderButton, findsOneWidget);
    });

    testWidgets("Fill Form", (WidgetTester tester) async {
      final OrderData orderData = OrderData.empty();
      orderData.randomizeOrder();

      await tester.pumpWidget(MaterialApp(
        home: Payment(orderData: orderData,),
      ));

      //key is x offset starting from the initial position(60); value is the slider value
      //for some reason grabbing the slider automatically puts it in the middle, also cant get to 20
      final Map<double, double> sliderOffsets = {
        -250.0: 30.0,
        -150.0: 40.0,
        -50.0: 50.0,
        0.0: 60.0,
        50.0: 70.0,
        150.0: 80.0,
        350.0: 100.0,
      };
      randomKey(Map map) => map.entries.elementAt(Random().nextInt(map.length));

      //get random offset
      MapEntry<dynamic, dynamic> newRandom = randomKey(sliderOffsets);
      Slider paySlider = payAmountSliderPayForm.evaluate().single.widget as Slider;
      tester.ensureVisible(payAmountSliderPayForm);
      expect(paySlider.value, equals(20.0));
      await tester.drag(payAmountSliderPayForm, Offset(newRandom.key, 0));
      await tester.pump();

      //check slider value is correct
      paySlider = payAmountSliderPayForm.evaluate().single.widget as Slider;
      expect(paySlider.value, equals(newRandom.value));
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

      expect(resetPassSettingsButton, findsOneWidget);
    });
  });

  //cannot do second order page until fix render issue
}