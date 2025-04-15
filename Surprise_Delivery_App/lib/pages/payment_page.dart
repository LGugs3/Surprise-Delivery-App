import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
import 'package:surpirse_delivery_app/reusable_widgets/meal_class.dart';
import 'package:surpirse_delivery_app/reusable_widgets/order_data_class.dart';
import 'package:surpirse_delivery_app/reusable_widgets/resolved_order_class.dart';
import 'package:http/http.dart' as http;

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
                ),
              ),
              Slider(
                value: _paymentAmount,
                min: 20.0,
                max: 100.0,
                divisions: 8,
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
                            builder: (context) =>
                                HomePage()), // will be changed to some sort of order processing/delivery page
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //this needs to be moved to the page the user is directed to
      //after this one(including the functions)
      fetchPotentialMeals();
    });
  }

  Future<Map<String, dynamic>?> getMealByID(String id) async
  {
    final http.Response response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id"));

    if (response.statusCode != 200){
      print("Bad http request; error ${response.statusCode}");
      return null;
    }
    else{
      Map<String, dynamic> decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded["meals"][0];
    }
  }

  void fetchPotentialMeals() async
  {
    Set<String> warningsList = {};

    if (orderData.cuisineSelection == "Random"){
      Random rng = Random();
      //-1 to exclude "random" option
      orderData.cuisineSelection = cuisineOptions[rng.nextInt(cuisineOptions.length - 1)];
    }
    final Uri apiUri = Uri.parse("https://www.themealdb.com/api/json/v1/1/filter.php?a=${orderData.cuisineSelection}");
    final http.Response response = await http.get(apiUri);

    if (response.statusCode != 200) {
      //replace with ui element that says "we couldnt find your order"
      print("Bad http request; error ${response.statusCode}");
      warningsList.add("Failed to fetch meal database");
    }
    else
    {
      Map<String, dynamic> cuisineCategory = jsonDecode(response.body) as Map<String, dynamic>;
      if (orderData.orderedMeals.length  > cuisineCategory["meals"].length){
        //isnt accurate but close enough
        warningsList.add("number of meals ordered is greater than possible meals");
      }


      //print((await getMealByID(cuisineCategory["meals"][0]["idMeal"]))?.keys);
      List<Map<String, dynamic>> mainMeals = List<Map<String, dynamic>>.empty(growable: true);
      List<Map<String, dynamic>> sideMeals = List<Map<String, dynamic>>.empty(growable: true);
      List<Map<String, dynamic>> dessertMeals = List<Map<String, dynamic>>.empty(growable: true);

      for(Map<String, dynamic> meal in cuisineCategory["meals"]){
        Map<String, dynamic>? nextMeal = await getMealByID(meal["idMeal"]);
        if (nextMeal == null){
          warningsList.add("some meals were not able to be fetched");
        }
        else{
          //add meal to one of the three lists
          String nextCat = nextMeal["strCategory"];
          if(nextCat == "Dessert"){
            dessertMeals.add(nextMeal);
          }
          else if (nextCat == "Side"){
            sideMeals.add(nextMeal);
          }
          else{
            mainMeals.add(nextMeal);
          }
        }
      }
      buildOrder(dessertMeals, sideMeals, mainMeals, warningsList);
    }
  }

  List<String> addMealOfType(List<Map<String, dynamic>> mealList, int mealCount, Set<String> warningsList)
  {
    List<String> returnedMeals = List<String>.empty(growable: true);
    Random rng = Random();
    for(int i = 0; i < mealCount; i++){
      if(mealList.isEmpty){
        warningsList.add("Not able to fetch proper number of meals due to request number was too high.");
        break;
      }
      int nextRng = rng.nextInt(mealList.length);
      returnedMeals.add(mealList[nextRng]["strMeal"]);
      mealList.removeAt(nextRng);
    }
    return returnedMeals;
  }

  void buildOrder(List<Map<String, dynamic>> dessertMeals,
                  List<Map<String, dynamic>> sideMeals,
                  List<Map<String, dynamic>> mainMeals,
                  Set<String> warningsList)
  {
    //check for dietary restrictions in seperate func here
    //remove meals with conflicting dietary restrictions/allergies in that func
    //add one more parameter for drinks
    ResolvedOrder finalOrder = ResolvedOrder();
    for(Meal meal in orderData.orderedMeals){
      ResolvedMeal finalMeal = finalOrder.add();

      finalMeal.mainMeals.addAll(addMealOfType(mainMeals, meal.mainCount, warningsList));
      finalMeal.sideMeals.addAll(addMealOfType(sideMeals, meal.sideCount, warningsList));
      finalMeal.dessertMeals.addAll(addMealOfType(dessertMeals, meal.dessertCount, warningsList));

    }

    //desired output for user
    for(ResolvedMeal finalMeal in finalOrder.meals){
      print(finalMeal.mainMeals);
      print(finalMeal.sideMeals);
      print(finalMeal.dessertMeals);
    }
    print(warningsList);
  }
}
