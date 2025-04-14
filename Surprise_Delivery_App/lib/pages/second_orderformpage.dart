import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/pages/payment_page.dart';
import 'package:surpirse_delivery_app/reusable_widgets/meal_class.dart';


class SecondOrderPage extends StatefulWidget {
  const SecondOrderPage({super.key, required this.orderedMeals});

  final List<Meal> orderedMeals;
  @override
  State<SecondOrderPage> createState() {
    return _SecondOrderPageState(orderedMeals);
  }
}

class _SecondOrderPageState extends State<SecondOrderPage> {
  List<Meal> orderedMeals = [];
  _SecondOrderPageState(orderedMeals);

  // List of available cuisines
  final List<String> cuisineOptions = [
    'Fast Food',
    'Japanese',
    'Chinese',
    'Thai',
    'Italian',
    'Mexican',
    'Indian',
    'French',
    'Pub/Bar',
    'Fully Random'
  ];


  // Controllers for address inputs
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  // Selected cuisine
  String? _selectedCuisine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Help Us Pick!",
          style: GoogleFonts.lilitaOne(
            fontSize: 30,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4
              ..color = Colors.black,
          ),
        ),
        centerTitle: true,
        // ignore: deprecated_member_use
        backgroundColor: const Color.fromARGB(127, 249, 160, 34),
      ),
      body: SingleChildScrollView(
        child: Container(
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Cuisine Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Select Cuisine Type:",
                  style: GoogleFonts.lilitaOne(fontSize: 22),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade400, width: 2),
                ),
                child: DropdownButton<String>(
                  value: _selectedCuisine,
                  hint: Text('Choose a cuisine'),
                  isExpanded: true,
                  items: cuisineOptions.map((cuisine) {
                    return DropdownMenuItem<String>(
                      value: cuisine,
                      child: Text(cuisine, style: TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCuisine = newValue;
                    });
                  },
                ),
              ),

              SizedBox(height: 20),

              // Address Input Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Enter Your Delivery Address:",
                  style: GoogleFonts.lilitaOne(fontSize: 22),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade400, width: 2),
                ),
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Enter your address...',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(height: 20),

              // City Input Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Enter Your City:",
                  style: GoogleFonts.lilitaOne(fontSize: 22),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade400, width: 2),
                ),
                child: TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: 'Enter your city...',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(height: 20),

              // State Input Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Enter Your State:",
                  style: GoogleFonts.lilitaOne(fontSize: 22),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade400, width: 2),
                ),
                child: TextField(
                  controller: _stateController,
                  decoration: InputDecoration(
                    hintText: 'Enter your state...',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(height: 20),

              // ZipCode Input Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Enter Your Zip Code:",
                  style: GoogleFonts.lilitaOne(fontSize: 22),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade400, width: 2),
                ),
                child: TextField(
                  controller: _zipCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter your zip code...',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 18),
                ),
              ),

              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle order submission logic
                    String selectedCuisine =
                        _selectedCuisine ?? 'No cuisine selected';
                    String deliveryAddress = _addressController.text;
                    String city = _cityController.text;
                    String state = _stateController.text;
                    String zipCode = _zipCodeController.text;

                    if (deliveryAddress.isEmpty ||
                        city.isEmpty ||
                        state.isEmpty ||
                        zipCode.isEmpty) {
                      // Show error if any of the fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please complete all fields')),
                      );
                    } else {
                      // Handle the order submission logic
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Payment(orderedMeals: orderedMeals,)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    "Continue To Payment",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
