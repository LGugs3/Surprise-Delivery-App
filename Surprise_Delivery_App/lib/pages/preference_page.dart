import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:surpirse_delivery_app/reusable_widgets/reusable_widget.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  final TextEditingController answerInputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("faf31f"),
          hexStringToColor("faae1f"),
          hexStringToColor("ff9999")
        ], begin: Alignment.topCenter, 
        end: Alignment.bottomCenter),
        ),
child: Padding(
          padding: const EdgeInsets.all(10.0), // Padding around the white box
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // Box takes 90% of screen width
              height: 900, // Adjust height as needed
              decoration: BoxDecoration(
                color: Colors.white, // White background for the box
                borderRadius: BorderRadius.circular(12), // Optional rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1), // Light shadow for depth
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Centering content vertically
                children: <Widget>[
                  ElevatedButton(
                    child: Text("Go to HomePage"),
                    onPressed: () {
                      // Navigate to the HomePage when pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(), // Change this to your HomePage class
                        ),
                      );
                    },
                  ),
                  // Add more widgets below if needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}