// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surpirse_delivery_app/reusable_widgets/reusable_widget.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
import 'package:surpirse_delivery_app/pages/reset_password.dart';
import 'package:surpirse_delivery_app/pages/signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  // Signin function
  void _signIn() {
    // Check if the fields are empty
    if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
      // Show a Snackbar with a message if the fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fields cannot be left blank. New to UPick? Sign up below!'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Exit the function early
    }

    // Sign the user in
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text)
        .then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }).onError((error, stackTrace) {
      // If credentials are invalid, notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid username or email and password'),
          duration: const Duration(seconds: 2),
        ),
      );
      print("Error ${error.toString()}"); // Optional: log the error for debugging
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("faf31f"),
          hexStringToColor("faae1f"),
          hexStringToColor("fa7f1f")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/UP.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Username or Email", Icons.person_outline, false,
                _emailTextController, givenKey: Key("Email Input")),

                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController, givenKey: Key("Password Input"),
                  textInputAction: TextInputAction.done, onSubmitted: (_) => _signIn(),),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(givenKey: Key("Login Submit"), context, "Sign In", _signIn,),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Create a free account.",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpPage()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
