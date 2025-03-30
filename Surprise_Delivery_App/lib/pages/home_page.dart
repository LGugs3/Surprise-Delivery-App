// ignore_for_file: use_super_parameters, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:surpirse_delivery_app/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';
import 'package:surpirse_delivery_app/pages/order_form.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Row buttonRow(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Column(
        children: <Widget>[
          ElevatedButton(
            key: Key("home-page-order"),
            child:
            const Text("Place Order"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderForm()),
              );
            },
          )
        ],
      ),
      Column(
        children: <Widget>[
          ElevatedButton(
            key: Key("View Map"),
            child:
            const Text("View Map"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BaseMap()),
              );
            },
          )
        ],
      ),
      Column(
        children: <Widget>[
          ElevatedButton(
            key: Key("Settings Button"),
            child: const Text("Settings"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      )
    ],
  );
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("HomePage Widget"),
      appBar: AppBar(
        title: const Text("UPick"),
        backgroundColor: const Color.fromARGB(255, 239, 214, 29).withOpacity(0.5),
        actions: [
          IconButton(
            key: Key("home-logout-button"),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInPage()));
              });
            },
          )
        ],
      ),
      body: Container(
        // Add the gradient as the background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("2ec7a3"),
              hexStringToColor("12e0b0"),
              hexStringToColor("0fb5ec"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
            child: buttonRow(context),
          ),
        ),
      ),
    );
  }

  // Helper function to convert hex string to Color
  Color hexStringToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
