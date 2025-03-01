import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({super.key});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  //allergies list
  final List<String> allergiesOptions = [
    'Peanuts',
    'Tree Nuts',
    'Dairy',
    'Sesame',
    'Soy',
    'Shellfish',
    'Fish',
    'Eggs'
  ];

  //dietary restrictions list
  final List<String> dietaryRestrictionsOptions = [
    'Vegetarian',
    'Vegan',
    'Halal',
    'Kosher',
    'Pescatarian',
    'Gluten Free'
  ];

  // Selected items for allergies and dietary restrictions
  List<String> _selectedAllergies = [];
  List<String> _selectedDietaryRestrictions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Stack(
            children: [
              // Black border (outline effect)
              Text(
                "Help Us Pick!",
                style: GoogleFonts.lilitaOne(
                  fontSize: 30,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Colors.black, // Border color
                ),
              ),
              // Main text with color
              Text(
                "Help Us Pick!",
                style: GoogleFonts.lilitaOne(
                  fontSize: 30,
                  color: Colors.orange.shade400,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor:
              const Color.fromARGB(255, 239, 214, 29).withValues(alpha: 0.5),
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.orange.shade200,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns text inside to the left
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(0.8),
                    color: Colors.pink.shade50,
                    child: Text(
                      "Anything we should know for this meal?",
                      style: GoogleFonts.lilitaOne(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // Dropdown for Allergies
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Dropdown for Allergies
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100, // Background color
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                            border: Border.all(
                                color: Colors.orange.shade400,
                                width: 2), // Border color and width
                          ),
                          child: MultiSelectDialogField<String>(
                            items: allergiesOptions
                                .map((allergy) =>
                                    MultiSelectItem<String>(allergy, allergy))
                                .toList(),
                            title: Text("Select Allergies"),
                            selectedColor: Colors.orange.shade400,
                            buttonText: Text(
                              "Allergies",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            buttonIcon: Icon(Icons.arrow_drop_down),
                            onConfirm: (selectedValues) {
                              setState(() {
                                _selectedAllergies =
                                    selectedValues.cast<String>();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    // Dropdown for Dietary Restrictions
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      child: Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100, // Background color
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                            border: Border.all(
                                color: Colors.orange.shade400,
                                width: 2), // Border color and width
                          ),
                          child: MultiSelectDialogField<String>(
                            items: dietaryRestrictionsOptions
                                .map((restriction) => MultiSelectItem<String>(
                                    restriction, restriction))
                                .toList(),
                            title: Text("Select Dietary Restrictions"),
                            selectedColor: Colors.orange.shade400,
                            buttonText: Text(
                              "Dietary Restrictions",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            buttonIcon: Icon(Icons.arrow_drop_down),
                            onConfirm: (selectedValues) {
                              setState(() {
                                _selectedDietaryRestrictions =
                                    selectedValues.cast<String>();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(height: 12),
                Container(
                  width: 100,
                  height: 80,
                  alignment: Alignment.center,
                  color: Colors.orange.shade400,
                  child: Text(
                    "main:",
                    style: GoogleFonts.lilitaOne(fontSize: 24),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: 100,
                  height: 80,
                  alignment: Alignment.center,
                  color: Colors.orange.shade400,
                  child: Text(
                    "side:",
                    style: GoogleFonts.lilitaOne(fontSize: 24),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: 100,
                  height: 80,
                  alignment: Alignment.center,
                  color: Colors.orange.shade400,
                  child: Text(
                    "drink:",
                    style: GoogleFonts.lilitaOne(fontSize: 24),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: 100,
                  height: 80,
                  alignment: Alignment.center,
                  color: Colors.orange.shade400,
                  child: Text(
                    "dessert:",
                    style: GoogleFonts.lilitaOne(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
