// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:surpirse_delivery_app/pages/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surpirse_delivery_app/pages/second_orderformpage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  String getFirebaseUID()
  {
    return Firebase.apps.isEmpty ? "Unknown" : FirebaseAuth.instance.currentUser?.uid ?? "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Update preferences button
            ElevatedButton(
              key: Key("update-preferences-button"),
              child: const Text("Update Preferences"),
              onPressed: () {
                print("Update Food Preferences button pressed.");
              },
            ),
            // Reset Password Button (Sends to reset password Page)
            const SizedBox(height: 20), // Adds spacing between buttons
            ElevatedButton(
              key: Key("reset-password-settings"),
              child: const Text(
                "Reset Password",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPassword()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              key: Key("second-order-form-button"),
              child: ElevatedButton(
                child: const Text("Second Order Form Page"),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondOrderPage(orderedMeals: [],)),
                  );
                },
              ),
            )
            ,
            // Footer that displays User's Firebase UID
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'User ID: ${getFirebaseUID()}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
