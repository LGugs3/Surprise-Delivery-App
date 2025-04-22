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
  Set<String> warningsList = {};

  //meal generation logic moved from payment page
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  Future<Map<String, dynamic>?> getDrinkByID(String id) async {
    final http.Response response = await http.get(
      Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id")
    );

    if (response.statusCode != 200) {
      print("Bad http request; error ${response.statusCode}");
      return null;
    }
    else{
      Map<String, dynamic> decoded = jsonDecode(response.body) as Map<String, dynamic>;
      return decoded["drinks"][0];
    }
  }

  void fetchPotentialMeals() async {

    if (orderData.cuisineSelection == "Random") {
      Random rng = Random();
      //-1 to exclude "random" option
      orderData.cuisineSelection =
          cuisineOptions[rng.nextInt(cuisineOptions.length - 1)];
    }
    final Uri mealUri = Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/filter.php?a=${orderData.cuisineSelection}");
    final http.Response mealResponse = await http.get(mealUri);

    final Uri adultDrinkUri = Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink");
    final http.Response adultDrinkResponse = await http.get(adultDrinkUri);

    final Uri kidsDrinkUri = Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic");
    final http.Response kidsDrinkResponse = await http.get(kidsDrinkUri);

    ResolvedOrder newOrder = ResolvedOrder();

    if (mealResponse.statusCode != 200) {
      //replace with ui element that says "we couldnt find your order"
      print("Bad http request; error ${mealResponse.statusCode}");
      warningsList.add("Failed to fetch meal database");
    }
    else {
      Map<String, dynamic> cuisineCategory =
          jsonDecode(mealResponse.body) as Map<String, dynamic>;

      List<Map<String, dynamic>> mainMeals =
          List<Map<String, dynamic>>.empty(growable: true);
      List<Map<String, dynamic>> sideMeals =
          List<Map<String, dynamic>>.empty(growable: true);
      List<Map<String, dynamic>> dessertMeals =
          List<Map<String, dynamic>>.empty(growable: true);

      //no meals returned
      if (cuisineCategory.isEmpty || cuisineCategory["meals"] == null) {
        print("fetched db is empty");
        warningsList.add("Fetched database is empty");
        return;
      }
      //sort meals into main, side and dessert
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
      buildMealOrder(dessertMeals, sideMeals, mainMeals, warningsList, newOrder);
    }


    if (adultDrinkResponse.statusCode != 200) {
      print("Bad http request; error ${mealResponse.statusCode}");
      warningsList.add("Failed to fetch drink database");
    }
    else{
      var adultDrinkMap = jsonDecode(adultDrinkResponse.body) as Map<String, dynamic>;
      var kidsDrinkMap = jsonDecode(kidsDrinkResponse.body) as Map<String, dynamic>;


      List<Map<String, dynamic>> nonAlcoholicDrinks =
          List<Map<String, dynamic>>.empty(growable: true);
      List<Map<String, dynamic>> alcoholicDrinks =
          List<Map<String, dynamic>>.empty(growable: true);

      for(Map<String, dynamic> drink in adultDrinkMap["drinks"]){
          alcoholicDrinks.add(drink);
      }
      for(Map<String, dynamic> drink in kidsDrinkMap["drinks"]){
        nonAlcoholicDrinks.add(drink);
      }

    buildDrinkOrder(alcoholicDrinks, nonAlcoholicDrinks, warningsList, newOrder);
    }

    setState(() {
      finalOrder = newOrder;
      isLoading = false;
    });
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

  List<String> addDrinkOfType(List<Map<String, dynamic>> drinkList, int drinkCount,
      Set<String> warningsList)
  {
    List<String> returnedDrinks = List<String>.empty(growable: true);
    Random rng = Random();
    for (int i = 0; i < drinkCount; i++) {
      if (drinkList.isEmpty) {
        warningsList.add(
            "Not able to fetch proper number of drinks due to request number was too high.");
        break;
      }
      int nextRng = rng.nextInt(drinkList.length);
      returnedDrinks.add(drinkList[nextRng]["strDrink"]);
      drinkList.removeAt(nextRng);
    }
     return returnedDrinks;
  }

  void buildMealOrder(
      final List<Map<String, dynamic>> dessertMeals,
      final List<Map<String, dynamic>> sideMeals,
      final List<Map<String, dynamic>> mainMeals,
      Set<String> warningsList,
      ResolvedOrder newOrder) {
    //ResolvedOrder newOrder = ResolvedOrder();
    for (Meal meal in orderData.orderedMeals) {
      ResolvedMeal finalMeal = newOrder.add();
      //create copies to be able to reuse original
      List<Map<String, dynamic>> filteredMain = (jsonDecode(json.encode(mainMeals)) as List).map((dynamic e) => e as Map<String, dynamic>).toList();
      List<Map<String, dynamic>> filteredSide = (jsonDecode(json.encode(sideMeals)) as List).map((dynamic e) => e as Map<String, dynamic>).toList();
      List<Map<String, dynamic>> filteredDessert = (jsonDecode(json.encode(dessertMeals)) as List).map((dynamic e) => e as Map<String, dynamic>).toList();

      removeConflictions(filteredMain, meal);
      removeConflictions(filteredSide, meal);
      removeConflictions(filteredDessert, meal);


      finalMeal.mainMeals
          .addAll(addMealOfType(filteredMain, meal.mainCount, warningsList));
      finalMeal.sideMeals
          .addAll(addMealOfType(filteredSide, meal.sideCount, warningsList));
      finalMeal.dessertMeals
          .addAll(addMealOfType(filteredDessert, meal.dessertCount, warningsList));
    }
  }

  void buildDrinkOrder(List<Map<String, dynamic>> alcoholicDrinks,
                      List<Map<String, dynamic>> nonAlcoholicDrinks,
                      Set<String> warningsList,
                      ResolvedOrder newOrder)
  {
    for (int i = 0; i < orderData.orderedMeals.length; i++){
      Meal meal = orderData.orderedMeals[i];
      ResolvedMeal finalMeal = newOrder.meals[i];

      if (meal.isKidsMeal){
        finalMeal.drinks
            .addAll(addDrinkOfType(nonAlcoholicDrinks, meal.drinkCount, warningsList));
      }else {
        finalMeal.drinks
            .addAll(addDrinkOfType(alcoholicDrinks, meal.drinkCount, warningsList));
      }

      //idk if this is needed, too lazy to check
      newOrder.meals[i] = finalMeal;
    }
  }

  void removeConflictions(List<Map<String, dynamic>> mealList, final Meal meal){
    //dietary restrictions
    for (String option in meal.selectedDietaryRestrictions){
      if (option == "Halal"){
        removeMealsWithCats(mealList, [option]);
      }
      else if (option == "Pescatarian"){
        keepMealsWithCats(mealList, ["Seafood"]);
      }
      else{
        keepMealsWithCats(mealList, [option]);
      }
    }

    //allergies
    //key: allergy restriction on form
    //value: list of ingredients/ingredient substrings in db to match key
    Map<String, List<String>> allergicIngredients = {
      "Peanuts": ["Peanut"],
      "Tree Nuts": ["Nuts", "nuts"],
      "Dairy": ["Cheese", "Ice Cream", "Butter", "Milk", "Cream", "Yogurt",
                "Sour Cream", "Ghee", "Cream Cheese", "Christmas Pudding",
                "Black Pudding"],
      "Sesame": ["Sesame"],
      "Soy": ["Soy"],
      "Eggs": ["Eggs"]
    };

    for (String option in meal.selectedAllergies){
      if (option == "Shellfish" || option == " Fish"){
        removeMealsWithCats(mealList, ["Seafood"]);
      }
      else{
        mealList.removeWhere((map) {
          for(int i = 1; i < 21; i++){
            //checks if any of the ingredients in the current meal match with restricted ingredients
            bool? result = allergicIngredients[option]?.any((allergy) => map["strIngredient$i"].toString().contains(allergy));
            if (result != null && result) return true;
          }
          return false;
        });
      }
    }
  }

  void removeMealsWithCats(List<Map<String, dynamic>> mealList, final List<String> blackListedCats){
    for (String cat in blackListedCats){
      mealList.removeWhere((map) => map["strCategory"] == cat);
    }
  }
  
  void keepMealsWithCats(List<Map<String, dynamic>> mealList, final List<String> whiteListedCats){
    for (String cat in whiteListedCats){
      mealList.retainWhere((map) => map["strCategory"] == cat);
    }
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

  Widget buildWarningsDisplay(){
    if (warningsList.isEmpty) return Column();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Warnings:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...warningsList.map((warning) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Text(warning),
        ))
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
                    false, // makes it so you cant go back to receipt and back and back...
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
                                if (meal.dessertMeals.isNotEmpty)
                                  buildMealDisplay("Drinks:", meal.drinks),
                                Divider(thickness: 4),
                              ],
                              buildWarningsDisplay()
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
