/*import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';

class SecondOrderPage extends StatefulWidget {
  const SecondOrderPage({super.key});

  @override
  State<SecondOrderPage> createState() => _SecondOrderPageState();
}

class _SecondOrderPageState extends State<SecondOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          backgroundColor:
              const Color.fromARGB(255, 249, 160, 34).withValues(alpha: 0.5),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("2ec7a3"),
            hexStringToColor("12e0b0"),
            hexStringToColor("0fb5ec")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        ));
  }
}*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';

class SecondOrderPage extends StatefulWidget {
  const SecondOrderPage({super.key});

  @override
  State<SecondOrderPage> createState() => _SecondOrderPageState();
}

class _SecondOrderPageState extends State<SecondOrderPage> {
  // List of available cuisines
  final List<String> cuisineOptions = [
    'Fast Food',
    'Buffet',
    'Chinese Food',
    'Thai Food',
    'Italian',
    'Mexican',
    'Indian'
  ];

  // Controller to get the address input
  final TextEditingController _addressController = TextEditingController();
  
  // Selected cuisine
  String? _selectedCuisine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: const Color.fromARGB(255, 249, 160, 34).withOpacity(0.5),
      ),
      body: Container(
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

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Here you can handle the order submission logic, such as saving the selections.
                  String selectedCuisine = _selectedCuisine ?? 'No cuisine selected';
                  String deliveryAddress = _addressController.text;

                  if (deliveryAddress.isEmpty) {
                    // Show an error if no address is entered
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a delivery address')),
                    );
                  } else {
                    // Handle the order submission logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Order placed: $selectedCuisine, Delivery to: $deliveryAddress'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade400,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(
                  "Place Order",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
