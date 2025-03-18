// ignore_for_file: use_super_parameters, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:surpirse_delivery_app/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Row buttonRow(BuildContext context)
{
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Column(
        children: <Widget>[
          ElevatedButton(
            child:
            const Text("Place Order"),
            onPressed: () {
              print("Place Order button pressed.");
            },
          )
        ],
      ),
      Column(
        children: <Widget>[
          ElevatedButton(
            child:
            const Text("View Map"),
            onPressed: () {
              print("View Map button pressed.");
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
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("UPick"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: (){
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed out");
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInPage()));
              });
            },
          )
        ],
      ),
      body: Center(
        child:
          Padding(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
            child: buttonRow(context),
          ),
      ),
    );
  }
}
