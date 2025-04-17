import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surpirse_delivery_app/utils/color_utils.dart';
import 'package:surpirse_delivery_app/pages/home_page.dart';
import 'package:surpirse_delivery_app/reusable_widgets/meal_class.dart';
import 'package:surpirse_delivery_app/reusable_widgets/resolved_order_class.dart';
import 'package:surpirse_delivery_app/reusable_widgets/order_data_class.dart';
import 'package:http/http.dart' as http;

class Reciept extends StatefulWidget {
  const Reciept({super.key, required this.orderData});

  final OrderData orderData;

  @override
  State<Reciept> createState() {
    return _RecieptState(orderData);
  }
}

class _RecieptState extends State<Reciept> {
  late OrderData orderData;
  _RecieptState(this.orderData);
  ResolvedOrder? finalOrder;
  bool isLoading = true;

  //meal generation logic moved from payment page
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //this needs to be moved to the page the user is directed to
      //after this one(including the functions)
      fetchPotentialMeals();
    });
  }

  Future<Map<String, dynamic>?> getMealByID(String id) async {
    final http.Response response = await http.get(
        Uri.parse("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id"));

    if (response.statusCode != 200) {
      print("Bad http request; error ${response.statusCode}");
      return null;
    } else {
      Map<String, dynamic> decoded =
          jsonDecode(response.body) as Map<String, dynamic>;
      return decoded["meals"][0];
    }
  }

  void fetchPotentialMeals() async {
    Set<String> warningsList = {};

    if (orderData.cuisineSelection == "Random") {
      Random rng = Random();
      //-1 to exclude "random" option
      orderData.cuisineSelection =
          cuisineOptions[rng.nextInt(cuisineOptions.length - 1)];
    }
    final Uri apiUri = Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/filter.php?a=${orderData.cuisineSelection}");
    final http.Response response = await http.get(apiUri);

    if (response.statusCode != 200) {
      //replace with ui element that says "we couldnt find your order"
      print("Bad http request; error ${response.statusCode}");
      warningsList.add("Failed to fetch meal database");
    } else {
      Map<String, dynamic> cuisineCategory =
          jsonDecode(response.body) as Map<String, dynamic>;

      //print((await getMealByID(cuisineCategory["meals"][0]["idMeal"]))?.keys);
      List<Map<String, dynamic>> mainMeals =
          List<Map<String, dynamic>>.empty(growable: true);
      List<Map<String, dynamic>> sideMeals =
          List<Map<String, dynamic>>.empty(growable: true);
      List<Map<String, dynamic>> dessertMeals =
          List<Map<String, dynamic>>.empty(growable: true);

      if (cuisineCategory.isEmpty || cuisineCategory["meals"] == null) {
        print("fetched db is empty");
        warningsList.add("Fetched database is empty");
        return;
      }
      for (Map<String, dynamic> meal in cuisineCategory["meals"]) {
        Map<String, dynamic>? nextMeal = await getMealByID(meal["idMeal"]);
        if (nextMeal == null) {
          warningsList.add("some meals were not able to be fetched");
          continue;
        } else {
          if (nextMeal.isEmpty) {
            warningsList.add("some meals were not able to be fetched");
            continue;
          }
          //add meal to one of the three lists
          String nextCat = nextMeal["strCategory"];
          if (nextCat == "Dessert") {
            dessertMeals.add(nextMeal);
          } else if (nextCat == "Side") {
            sideMeals.add(nextMeal);
          } else {
            mainMeals.add(nextMeal);
          }
        }
      }
      buildOrder(dessertMeals, sideMeals, mainMeals, warningsList);
    }
  }

  List<String> addMealOfType(List<Map<String, dynamic>> mealList, int mealCount,
      Set<String> warningsList) {
    List<String> returnedMeals = List<String>.empty(growable: true);
    Random rng = Random();
    for (int i = 0; i < mealCount; i++) {
      if (mealList.isEmpty) {
        warningsList.add(
            "Not able to fetch proper number of meals due to request number was too high.");
        break;
      }
      int nextRng = rng.nextInt(mealList.length);
      returnedMeals.add(mealList[nextRng]["strMeal"]);
      mealList.removeAt(nextRng);
    }
    return returnedMeals;
  }

  void buildOrder(
      List<Map<String, dynamic>> dessertMeals,
      List<Map<String, dynamic>> sideMeals,
      List<Map<String, dynamic>> mainMeals,
      Set<String> warningsList) {
    //check for dietary restrictions in seperate func here
    //remove meals with conflicting dietary restrictions/allergies in that func
    //add one more parameter for drinks
    ResolvedOrder newOrder = ResolvedOrder();
    for (Meal meal in orderData.orderedMeals) {
      ResolvedMeal finalMeal = newOrder.add();

      finalMeal.mainMeals
          .addAll(addMealOfType(mainMeals, meal.mainCount, warningsList));
      finalMeal.sideMeals
          .addAll(addMealOfType(sideMeals, meal.sideCount, warningsList));
      finalMeal.dessertMeals
          .addAll(addMealOfType(dessertMeals, meal.dessertCount, warningsList));
    }

    setState(() {
      finalOrder = newOrder;
      isLoading = false;
    });
    //desired output for user
    for (ResolvedMeal finalMeal in newOrder.meals) {
      print(finalMeal.mainMeals);
      print(finalMeal.sideMeals);
      print(finalMeal.dessertMeals);
    }
    print(warningsList);
  }

  Widget buildMealDisplay(String title, List<String> meals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...meals.map((meal) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(meal),
            )),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Hope You Enjoy!",
          style: GoogleFonts.lilitaOne(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: hexStringToColor("2ec7a3"),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) =>
                    false, // makes it so you cant go back to reciept and back and back...
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var meal in finalOrder!.meals) ...[
                                if (meal.mainMeals.isNotEmpty)
                                  buildMealDisplay(
                                      "Main Meals:", meal.mainMeals),
                                if (meal.sideMeals.isNotEmpty)
                                  buildMealDisplay(
                                      "Side Meals:", meal.sideMeals),
                                if (meal.dessertMeals.isNotEmpty)
                                  buildMealDisplay(
                                      "Desserts:", meal.dessertMeals),
                                Divider(thickness: 2),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
