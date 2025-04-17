import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:surpirse_delivery_app/pages/second_orderformpage.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/reusable_widgets/meal_class.dart';
import 'package:surpirse_delivery_app/reusable_widgets/order_data_class.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({super.key});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  // Allergies list
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

  // Dietary restrictions list
  final List<String> dietaryRestrictionsOptions = [
    'Vegetarian',
    'Vegan',
    'Halal',
    'Kosher',
    'Pescatarian',
    'Gluten Free'
  ];

  // List to store meal data
  final List<Meal> _meals = [Meal()];

  // Function to add a new meal
  void _addMeal() {
    setState(() {
      _meals.add(Meal());
    });
  }

  // Function to add a kids meal
  void _addKidsMeal() {
    setState(() {
      _meals.add(Meal(isKidsMeal: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      appBar: AppBar(
        title: Stack(
          children: [
            Text(
              "Help Us Pick!",
              style: GoogleFonts.lilitaOne(
                fontSize: 30,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4
                  ..color = Colors.black,
              ),
            ),
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
      body: Column(
        children: [
          // List of meals inside Expanded widget
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    hexStringToColor("2ec7a3"),
                    hexStringToColor("12e0b0"),
                    hexStringToColor("0fb5ec")
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                itemCount: _meals.length +
                    2, // Extra 2 for the Add Meal button and Kids Meal
                itemBuilder: (context, index) {
                  if (index < _meals.length) {
                    return _buildMealElement(_meals[index], index);
                  } else if (index == _meals.length) {
                    // Add Meal button at the bottom of the list
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FloatingActionButton(
                        onPressed: _addMeal,
                        key: Key("add-meal-button"),
                        heroTag: 'add-meal-hero-button',
                        backgroundColor: Colors.orange.shade400,
                        child: Icon(Icons.add),
                      ),
                    );
                  } else {
                    // Kids Meal button
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: FloatingActionButton(
                        onPressed: _addKidsMeal,
                        key: Key("add-kids-meal-button"),
                        heroTag: 'add-kids-meal-hero-button',
                        backgroundColor: Colors.orange.shade400,
                        child: Icon(Icons.child_care),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              key: Key("second-page-order"),
              onPressed: () {
                bool isValid = false;
                if (_meals.every((meal) =>
                    meal.isKidsMeal ||
                    meal.mainCount > 0 ||
                    meal.sideCount > 0 ||
                    meal.drinkCount > 0 ||
                    meal.dessertCount > 0))
                  {
                    // If meals are valid, Proceed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondOrderPage(orderData: OrderData.init(_meals),)),
                    );
                  }
                else
                  {
                    // Prompt user to order/select something
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('One of your meals has no items selected. Please add an item regardless of category or delete excess meals.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade400, // Button color
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              ),
              child: const Text(
                "Continue Selection",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // method to build each meal
  Widget _buildMealElement(Meal meal, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.pink.shade200, width: 2),
      ),
      key: Key("meal-container"),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Display "Kids Meal" if it's a kids meal, else "Meal"
              Text(
                meal.isKidsMeal
                    ? "Kids Meal ${index + 1}"
                    : "Meal ${index + 1}",
                style: GoogleFonts.lilitaOne(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  // Remove the meal from the list
                  setState(() {
                    _meals.removeAt(index);
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          _buildMealItem("Main", meal, "main", index),
          _buildMealItem("Side", meal, "side", index),
          _buildMealItem("Drink", meal, "drink", index),
          _buildMealItem("Dessert", meal, "dessert", index),
          SizedBox(height: 12),
          // Dropdowns for allergies and dietary restrictions
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDropdown(meal, "allergies", index),
              SizedBox(height: 8),
              _buildDropdown(meal, "dietaryRestrictions", index),
            ],
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  // method to build each meal item (main, side, drink, dessert)
  Widget _buildMealItem(String label, Meal meal, String mealType, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$label:",
          style: GoogleFonts.lilitaOne(fontSize: 18),
        ),
        Spacer(),
        // If it's a kids meal, we don't allow increment/decrement
        meal.isKidsMeal
            ? Text(
                "1", // Always 1 for kids meal
                style: GoogleFonts.lilitaOne(fontSize: 20),
              )
            : _buildCounterButtons(meal, mealType),
      ],
    );
  }

  // Counter buttons
  Widget _buildCounterButtons(Meal meal, String mealType) {
    return Row(
      children: <Widget>[
        IconButton(
          key: Key("dec-$mealType-acc"),
          icon: Icon(Icons.remove, color: Colors.orange.shade400),
          onPressed: () {
            setState(() {
              meal.decrementCounter(mealType);
            });
          },
        ),
        Text(
          "${meal.getCounter(mealType)}",
          style: GoogleFonts.lilitaOne(fontSize: 20),
          key: Key("$mealType-acc-num"),
        ),
        IconButton(
          key: Key("inc-$mealType-acc"),
          icon: Icon(Icons.add, color: Colors.orange.shade400),
          onPressed: () {
            setState(() {
              meal.incrementCounter(mealType);
            });
          },
        ),
      ],
    );
  }

  // Dropdown for allergies or dietary restrictions
  Widget _buildDropdown(Meal meal, String type, int index) {
    List<String> options =
        type == "allergies" ? allergiesOptions : dietaryRestrictionsOptions;

    return MultiSelectDialogField<String>(
      items: options
          .map((option) => MultiSelectItem<String>(option, option))
          .toList(),
      title: Text(type == "allergies"
          ? "Select Allergies"
          : "Select Dietary Restrictions"),
      selectedColor: Colors.orange.shade400,
      buttonText: Text(
        type == "allergies" ? "Allergies" : "Dietary Restrictions",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      buttonIcon: Icon(Icons.arrow_drop_down),
      onConfirm: (selectedValues) {
        setState(() {
          if (type == "allergies") {
            meal.selectedAllergies = selectedValues.cast<String>();
          } else {
            meal.selectedDietaryRestrictions = selectedValues.cast<String>();
          }
        });
      },
    );
  }
}
