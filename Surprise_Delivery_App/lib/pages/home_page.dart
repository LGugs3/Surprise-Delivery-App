// ignore_for_file: use_super_parameters, avoid_print

import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surpirse_delivery_app/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:surpirse_delivery_app/pages/settings_page.dart';
import 'package:surpirse_delivery_app/pages/order_form.dart';
import 'package:surpirse_delivery_app/pages/base_map.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';

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
            child: const Text("Place Order"),
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
            child: const Text("View Map"),
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
  late ConfettiController _centerController;
  final List<String> cuisineOptions = [
    'Fast Food',
    'Japanese',
    'Chinese',
    'Thai',
    'Italian',
    'Mexican',
    'Indian',
    'French',
    'Pub/Bar'
  ];

  String selectedCuisine = "";
  bool flag = false;

  @override
  void initState() {
    super.initState();
    _centerController = ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonRow(context),
                SizedBox(height: 50), // Add space between buttons and the wheel
                // Fortune Wheel integration
                GestureDetector(
                  onTap: () {
                    // Placeholder for wheel spin logic
                    setState(() {
                      // Trigger the wheel spin
                    });
                  },
                  child: SizedBox(
                    height: 400,
                    child: FortuneWheel(
                      selected: Stream.value(0), // Modify for actual logic
                      items: [
                        for (var it in cuisineOptions) FortuneItem(child: Text(it)),
                      ],
                      onAnimationEnd: () {
                        _centerController.play();
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text("Hurray! Today's cuisine is????"),
                                  content: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: SizedBox(
                                          width: 300,
                                          height: 300,
                                          child: Center(
                                            child: ConfettiWidget(
                                              confettiController: _centerController,
                                              blastDirection: pi,
                                              maxBlastForce: 10,
                                              minBlastForce: 1,
                                              emissionFrequency: 0.03,
                                              numberOfParticles: 100,
                                              gravity: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            selectedCuisine,
                                            style: TextStyle(fontSize: 22),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      onFocusItemChanged: (value) {
                        if (flag == true) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              selectedCuisine = cuisineOptions[value];
                            });
                          });
                        } else {
                          flag = true;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color hexStringToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) {
      buffer.write('ff');
    }
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}