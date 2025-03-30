import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';
import 'package:surpirse_delivery_app/pages/order_form.dart';
import 'package:surpirse_delivery_app/pages/reset_password.dart';
import 'package:surpirse_delivery_app/pages/second_orderformpage.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';

//sign-in widgets
Finder emailInput = find.byKey(Key("Email Input"));
Finder passInput = find.byKey(Key("Password Input"));
Finder submitButton = find.byKey(Key("Login Submit"));

//home page widgets
Finder viewMapButton = find.byKey(Key("View Map"));
Finder placeOrderButton = find.byKey(Key("home-page-order"));
Finder settingsButton = find.byKey(Key("Settings Button"));
Finder homeLogoutButton = find.byKey(Key("home-logout-button"));

//settings page
Finder settingsState = find.byType(SettingsPage);
Finder resetPassSettingsButton = find.byKey(Key("reset-password-settings"));
Finder secondOrderFormButton = find.byKey(Key("second-order-form-button"));
Finder updatePreferencesButton = find.byKey(Key("update-preferences-button"));

//second order form page
Finder secondOrderState = find.byType(SecondOrderPage);

//reset password page
Finder resetPasswordState = find.byType(ResetPassword);

//Base Map Widgets
Finder mapState = find.byType(BaseMap);

//order_form widgets
Finder addMealButton = find.byKey(Key("add-meal-button"));
Finder mealContainer = find.byKey(Key("meal-container"));
Finder orderState = find.byType(OrderForm);
//order form meal container contents
List<String> entreeTypes = ["main", "side", "drink", "dessert"];
Finder getMealContainerAcc(String name, bool isInc) {
  return isInc ? find.byKey(Key("inc-$name-acc")) : find.byKey(Key("dec-$name-acc"));
}
Finder getMealContainerCount(String name){
  return find.byKey(Key("$name-acc-num"));
}