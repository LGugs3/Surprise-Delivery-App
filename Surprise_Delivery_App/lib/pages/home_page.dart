// ignore_for_file: use_super_parameters, avoid_print

import 'dart:math';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
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
      ]);
}

class _HomePageState extends State<HomePage> {
  late ConfettiController _centerController;
  final StreamController<int> controller =
      StreamController<int>.broadcast(); // Use broadcast

  final List<String> cuisineOptions = [
    'American',
    'British',
    'Canadian',
    'Chinese',
    'Croatian',
    'Dutch',
    'Egyptian',
    'Filipino',
    'French',
    'Greek',
    'Indian',
    'Irish',
    'Italian',
    'Jamaican',
    'Japanese',
    'Kenyan',
    'Mexican',
    'Spanish',
    'Thai',
  ];

  String selectedCuisine = "";
  bool flag = false;
  // variable to control the selected item
  int selectedItem = 0;

  void initWheelSpin()
  {
    setState(() {
      selectedItem = Random().nextInt(cuisineOptions.length);
      controller.add(selectedItem);
    });
  }

  @override
  void initState() {
    _centerController =
        ConfettiController(duration: const Duration(seconds: 10));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initWheelSpin();
    });
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
        backgroundColor: const Color.fromARGB(127, 239, 214, 29),
        leading: IconButton(
          key: Key("home-settings-button"),
          icon: const Icon(Icons.settings),
          tooltip: 'Settings',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
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
                  SizedBox(height: 50),

                  // Row with Uey and speech bubble
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/images/Uey.png',
                            width: 200,
                            height: 200,
                          ),
                        ),
                        Stack(
                          children: [
                            Transform.translate(
                              offset: Offset(0, -40),
                              child: Image.asset(
                                'assets/images/speech_bubble.png',
                                width: 150,
                                height: 150,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 40,
                              child: Visibility(
                                visible: selectedCuisine.isNotEmpty,
                                child: Text(
                                  'Uey picks\n$selectedCuisine',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
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
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
                                              confettiController:
                                                  _centerController,
                                              blastDirection: pi,
                                              maxBlastForce: 10,
                                              minBlastForce: 1,
                                              emissionFrequency: 0.03,
                                              numberOfParticles: 50,
                                              gravity: 0,
                                              shouldLoop: false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            selectedCuisine = cuisineOptions[
                                value]; // Update state after build
                          });
                        });
                      },
                    ),
                  ),
                  // button below wheel
                  ElevatedButton(
                    onPressed: () {
                      spinWheel();
                    },
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
