import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';
import 'package:surpirse_delivery_app/pages/order_form.dart';
import 'package:surpirse_delivery_app/pages/payment_page.dart';
import 'package:surpirse_delivery_app/pages/reset_password.dart';
import 'package:surpirse_delivery_app/pages/second_orderformpage.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';

//pump duration
const Duration settleTime = Duration(seconds: 1);

//sign-in widgets
Finder emailInput = find.byKey(Key("Email Input"));
Finder passInput = find.byKey(Key("Password Input"));
Finder submitButton = find.byKey(Key("Login Submit"));

//home page widgets
Finder viewMapButton = find.byKey(Key("View Map"));
Finder placeOrderButton = find.byKey(Key("home-page-order"));
Finder settingsButton = find.byKey(Key("Settings Button"));
Finder homeLogoutButton = find.byKey(Key("home-logout-button"));
Finder homeWheelButton = find.byKey(Key("spin-wheel-button"));
Finder homeFortuneWheel = find.byKey(Key("fortune-wheel"));

//settings page
Finder settingsState = find.byType(SettingsPage);
Finder resetPassSettingsButton = find.byKey(Key("reset-password-settings"));
Finder secondOrderFormButton = find.byKey(Key("second-order-form-button"));
Finder updatePreferencesButton = find.byKey(Key("update-preferences-button"));

//second order form page
Finder secondOrderState = find.byType(SecondOrderPage);
Finder continuePaymentButton = find.byKey(Key("continue-payment-button"));
Finder cuisineTypeText = find.byKey(Key("cuisine-type-text-o2"));
Finder cuisineDropdownSecondForm = find.byKey(Key("cuisine-select-dropdown-o2"));
Finder addressTextSecondForm = find.byKey(Key("address-text-o2"));
Finder addressInputSecondForm = find.byKey(Key("address-input-o2"));
Finder cityTextSecondForm = find.byKey(Key("city-input-text-o2"));
Finder cityInputSecondForm = find.byKey(Key("city-input-o2"));
Finder stateTextSecondForm = find.byKey(Key("state-text-o2"));
Finder stateInputSecondForm = find.byKey(Key("state-input-o2"));
Finder zipTextSecondForm = find.byKey(Key("zip-text-o2"));
Finder zipInputSecondForm = find.byKey(Key("zip-input-o2"));
const List<String> cuisineTypes = [
  'Fast Food',
  'Japanese',
  'Chinese',
  'Thai',
  'Italian',
  'Mexican',
  'Indian',
  'French',
  'Pub/Bar',
  'Fully Random'
];
//map for fields
final Map<Finder, String> secondOrderFormInputFields = {
  addressInputSecondForm: "123 Orange st",
  cityInputSecondForm: "Coronado",
  stateInputSecondForm: "California",
  zipInputSecondForm: "92118",
};
Future<void> fillSecondOrderForm(WidgetTester tester, [int? rng]) async {
  //select dropdown button
  tester.ensureVisible(cuisineDropdownSecondForm);
  rng ??= Random().nextInt(cuisineTypes.length);
  await tester.tap(cuisineDropdownSecondForm);
  await tester.pump();

  //select random cuisine type
  Finder cuisineType = find.text(cuisineTypes[rng]);
  tester.ensureVisible(cuisineType);
  await tester.tap(cuisineType);
  await tester.pump();

  //fill text fields
  for(var field in secondOrderFormInputFields.entries)
  {
    tester.ensureVisible(field.key);
    await tester.enterText(field.key, field.value);
    await tester.pump();
  }
}

//payment page
Finder paymentState = find.byType(Payment);
Finder payAmountTextPayForm = find.byKey(Key("pay-amount-text-pay"));
Finder payAmountSliderPayForm = find.byKey(Key("pay-slider-pay"));
Finder credCardTextPayForm = find.byKey(Key("ccard-text-pay"));
Finder credCardInputPayForm = find.byKey(Key("ccard-input-pay"));
Finder expDateTextPayForm = find.byKey(Key("exp-date-text-pay"));
Finder expDateInputPayForm = find.byKey(Key("exp-date-input-pay"));
Finder secCodeTextPayForm = find.byKey(Key("security-code-text-pay"));
Finder secCodeInputPayForm = find.byKey(Key("security-code-input-pay"));
Finder countryTextPayForm = find.byKey(Key("country-text-pay"));
Finder countryInputPayForm = find.byKey(Key("country-input-pay"));
Finder zipTextPayForm = find.byKey(Key("zip-text-pay"));
Finder zipInputPayForm = find.byKey(Key("zip-input-pay"));
Finder completeOrderButton = find.byKey(Key("place-order-button"));

//reset password page
Finder resetPasswordState = find.byType(ResetPassword);

//Base Map Widgets
Finder mapState = find.byType(BaseMap);

//order_form widgets
Finder addMealButton = find.byKey(Key("add-meal-button"));
Finder mealContainer = find.byKey(Key("meal-container"));
Finder continueOrderButton = find.byKey(Key("second-page-order"));
Finder orderState = find.byType(OrderForm);
//order form meal container contents
List<String> entreeTypes = ["main", "side", "drink", "dessert"];
Finder getMealContainerAcc(String name, bool isInc) {
  return isInc ? find.byKey(Key("inc-$name-acc")) : find.byKey(Key("dec-$name-acc"));
}
Finder getMealContainerCount(String name){
  return find.byKey(Key("$name-acc-num"));
}