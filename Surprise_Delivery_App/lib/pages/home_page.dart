// ignore_for_file: use_super_parameters, avoid_print

import 'dart:math';
import 'dart:async';
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

// the buttons for homepage are here
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
  final StreamController<int> controller = StreamController<int>.broadcast(); // Use broadcast

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
  // variable to control the selected item 
  int selectedItem = 0; 

  @override
  void initState() {
    super.initState();
    _centerController = ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _centerController.dispose();
    controller.close();
    super.dispose();
  }

  void spinWheel() {
    setState(() {
      // random selection
      selectedItem = Random().nextInt(cuisineOptions.length); 
    });
    // makes the wheel spin
    controller.add(selectedItem);
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
      // wrapped the body into scroll view
      body: SingleChildScrollView( 
        child: Container(
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
              // adjust the padding here
              padding: EdgeInsets.fromLTRB(0, 50, 0, 210), 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonRow(context),
                   // the space between buttons and the wheel
                  SizedBox(height: 200),

                  // fortune wheel integration
                  SizedBox(
                    height: 400,
                    child: FortuneWheel(
                      // this stream triggers the spin
                      selected: controller.stream, 
                      items: [
                        for (int i = 0; i < cuisineOptions.length; i++)
                          FortuneItem(
                            child: Text(
                              cuisineOptions[i],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            style: FortuneItemStyle(
                              // unique color randomly
                              color: getWheelColor(i), 
                              // border color
                              borderColor: Colors.white, 
                              // border thickness
                              borderWidth: 3, 
                            ),
                          ),
                      ],
                      // the animation pop-up after wheel ends
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
                  // button below wheel
                  ElevatedButton(
                    onPressed: spinWheel,
                    child: Text("Spin the Wheel!"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // these are the assigned colors for the wheel
  Color getWheelColor(int index) {
    List<Color> wheelColors = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.brown
    ];
    // loops through colors
    return wheelColors[index % wheelColors.length]; 
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