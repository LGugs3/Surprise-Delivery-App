import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surpirse_delivery_app/reusable_widgets/order_data_class.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/pages/payment_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surpirse_delivery_app/reusable_widgets/meal_class.dart';


class SecondOrderPage extends StatefulWidget {
  const SecondOrderPage({super.key, required this.orderData});

  final OrderData orderData;
  @override
  State<SecondOrderPage> createState() {
    return _SecondOrderPageState(orderData);
  }
}

class _SecondOrderPageState extends State<SecondOrderPage> {
  late OrderData orderData;
  _SecondOrderPageState(this.orderData);


  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  String? _selectedCuisine;
  String? _documentId;

  @override
  void initState() {
    super.initState();
    _loadUserDelivery();
  }

  Future<void> _loadUserDelivery() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final query = await FirebaseFirestore.instance
        .collection('deliveries')
        .where('uid', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final data = doc.data();

      setState(() {
        _documentId = doc.id;
        _selectedCuisine = data['cuisine'];
        _addressController.text = data['address'];
        _cityController.text = data['city'];
        _stateController.text = data['state'];
        _zipCodeController.text = data['zip'];
      });

      print("🟢 Loaded delivery data for ${user.email}");
    }
  }

  Future<void> _saveDelivery() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not signed in')),
      );
      return;
    }

    final String selectedCuisine = _selectedCuisine ?? '';
    final String address = _addressController.text.trim();
    final String city = _cityController.text.trim();
    final String state = _stateController.text.trim();
    final String zip = _zipCodeController.text.trim();

    if (address.isEmpty || city.isEmpty || state.isEmpty || zip.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final deliveryData = {
      'uid': user.uid,
      'email': user.email ?? '',
      'cuisine': selectedCuisine,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      if (_documentId != null) {
        await FirebaseFirestore.instance
            .collection('deliveries')
            .doc(_documentId)
            .update(deliveryData);
        print("✅ Updated delivery for ${user.email}");
      } else {
        final newDoc = await FirebaseFirestore.instance
            .collection('deliveries')
            .add(deliveryData);
        _documentId = newDoc.id;
        print("✅ Created new delivery for ${user.email}");
      }

      orderData.cuisineSelection = _selectedCuisine!;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Payment(orderData: orderData,)),
      );
    } catch (e) {
      print('🔥 Firestore error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving delivery: $e')),
      );
    }
  }

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
              _buildDropdownSection(),
              SizedBox(height: 20),
              _buildInputField("Enter Your Delivery Address:", _addressController),
              SizedBox(height: 20),
              _buildInputField("Enter Your City:", _cityController),
              SizedBox(height: 20),
              _buildInputField("Enter Your State:", _stateController),
              SizedBox(height: 20),
              _buildInputField("Enter Your Zip Code:", _zipCodeController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveDelivery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text("Continue To Payment", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select Cuisine Type:", style: GoogleFonts.lilitaOne(fontSize: 22)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade400, width: 2),
            ),
            child: DropdownButton<String>(
              value: cuisineOptions.contains(_selectedCuisine) ? _selectedCuisine : null,
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
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.lilitaOne(fontSize: 22)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade400, width: 2),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}