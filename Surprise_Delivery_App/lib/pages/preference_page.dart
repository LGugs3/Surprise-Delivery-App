import 'package:flutter/material.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<String> _favoriteFoods = [];
  final TextEditingController _foodController = TextEditingController();

  final List<String> foodOptions = [
    'Pizza',
    'Burger',
    'Pasta',
    'Sushi',
    'Salad',
    'Steak'
  ]; // Sample dropdown options

  String? _selectedFood;

  Future<void> _savePreferences() async {
    if (_favoriteFoods.isNotEmpty) {
      await FirebaseFirestore.instance.collection('favoriteFoods').add({
        'foods': _favoriteFoods,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Favorite foods saved!')),
      );

      _favoriteFoods.clear(); // Clear list after saving
      _foodController.clear();
      setState(() {}); // Update UI
    }
  }

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
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 900, // Adjust height as needed
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedFood,
                          decoration: InputDecoration(
                            labelText: "Select Favorite Food",
                            border: OutlineInputBorder(),
                          ),
                          items: foodOptions.map((String food) {
                            return DropdownMenuItem<String>(
                              value: food,
                              child: Text(food),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFood = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedFood != null &&
                                !_favoriteFoods.contains(_selectedFood)) {
                              setState(() {
                                _favoriteFoods.add(_selectedFood!);
                              });
                            }
                          },
                          child: Text("Add to Favorites"),
                        ),
                        SizedBox(height: 10),
                        Text("Favorite Foods:"),
                        Wrap(
                          children: _favoriteFoods
                              .map((food) => Chip(label: Text(food)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _savePreferences,
                    child: Text("Save Preferences"),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text("Go to Home Page"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
