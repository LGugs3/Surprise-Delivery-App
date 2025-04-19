import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/pages/reciept_page.dart';
import 'package:surpirse_delivery_app/reusable_widgets/order_data_class.dart';

class Payment extends StatefulWidget {
  const Payment({super.key, required this.orderData});

  final OrderData orderData;

  @override
  State<Payment> createState() {
    return _PaymentState(orderData);
  }
}

class _PaymentState extends State<Payment> {
  late OrderData orderData;
  _PaymentState(this.orderData);

  // Controllers for card details
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expirationController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  double _paymentAmount = 20.0;

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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Payment Amount: \$${_paymentAmount.toStringAsFixed(2)}",
                  style: GoogleFonts.lilitaOne(fontSize: 22),
                  key: Key("pay-amount-text-pay"),
                ),
              ),
              Slider(
                value: _paymentAmount,
                min: 20.0,
                max: 100.0,
                divisions: 8,
                key: Key("pay-slider-pay"),
                onChanged: (double newValue) {
                  setState(() {
                    _paymentAmount = newValue;
                  });
                },
                activeColor: Colors.orange.shade400,
                inactiveColor: const Color.fromARGB(255, 238, 234, 234),
                thumbColor: Colors.orange.shade400,
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Card Number:",
                  key: Key("ccard-text-pay"),
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
                  key: Key("ccard-input-pay"),
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    hintText: 'XXXX XXXX XXXX XXXX',
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
                  "Expiration:",
                  key: Key("exp-date-text-pay"),
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
                  key: Key("exp-date-input-pay"),
                  controller: _expirationController,
                  decoration: InputDecoration(
                    hintText: 'MM/YY',
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
                  "CVC:",
                  key: Key("security-code-text-pay"),
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
                  key: Key("security-code-input-pay"),
                  controller: _cvcController,
                  decoration: InputDecoration(
                    hintText: 'CVC',
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
                  "Country:",
                  key: Key("country-text-pay"),
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
                  key: Key("country-input-pay"),
                  controller: _countryController,
                  decoration: InputDecoration(
                    hintText: 'Country',
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
                  key: Key("zip-text-pay"),
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
                  key: Key("zip-input-pay"),
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
                  key: Key("place-order-button"),
                  onPressed: () {
                    // Handle order submission logic
                    String cardNumber = _cardNumberController.text;
                    String expiration = _expirationController.text;
                    String cvc = _cvcController.text;
                    String country = _countryController.text;
                    String zipCode = _zipCodeController.text;

                    if (cardNumber.isEmpty ||
                        expiration.isEmpty ||
                        cvc.isEmpty ||
                        country.isEmpty ||
                        zipCode.isEmpty) {
                      // Show error if any of the fields are empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please complete all fields')),
                      );
                    } else {
                      // Handle the order submission logic
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Reciept(orderData: orderData),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    "Complete Order",
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
