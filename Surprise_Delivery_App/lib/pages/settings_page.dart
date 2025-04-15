// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:surpirse_delivery_app/pages/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surpirse_delivery_app/pages/second_orderformpage.dart';
import 'package:surpirse_delivery_app/reusable_widgets/order_data_class.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  String getFirebaseUID() {
    return Firebase.apps.isEmpty
        ? "Unknown"
        : FirebaseAuth.instance.currentUser?.uid ?? "Unknown";
  }

  String getFirebaseEmail() {
    return Firebase.apps.isEmpty
        ? "Unknown"
        : FirebaseAuth.instance.currentUser?.email ?? "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: const Color.fromARGB(255, 69, 84, 91),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your ID: ${getFirebaseUID()}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 33, 9, 9),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Your Email: ${getFirebaseEmail()}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 33, 9, 9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //reset password button
                  Column(children: [
                    const SizedBox(height: 50, width: double.infinity),
                    ElevatedButton(
                      key: Key("reset-password-settings"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock_reset),
                          SizedBox(width: 10),
                          Text("Reset Password"),
                        ],
                      ),
                    ),
                  ]),
                ])));
  }
}
