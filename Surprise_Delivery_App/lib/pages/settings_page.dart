import 'package:flutter/material.dart';
import 'package:surpirse_delivery_app/pages/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatelessWidget {
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
              child: const Text("Update Preferences"),
              onPressed: () {
                print("Change Preferences button pressed.");
              },
            ),
            // Reset Password Button (Sends to reset password Page)
            const SizedBox(height: 20), // Adds spacing between buttons
            ElevatedButton(
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
            // Footer that displays User's Firebase UID
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'User ID: ${FirebaseAuth.instance.currentUser?.uid ?? 'Unknown'}',
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