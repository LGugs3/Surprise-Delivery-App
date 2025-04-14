// Meal class to hold the meal state
class Meal {
  int mainCount = 0;
  int sideCount = 0;
  int drinkCount = 0;
  int dessertCount = 0;
  List<String> selectedAllergies = [];
  List<String> selectedDietaryRestrictions = [];

  // Increment counter
  void incrementCounter(String mealType) {
    if (mealType == "main") {
      mainCount++;
    } else if (mealType == "side") {
      sideCount++;
    } else if (mealType == "drink") {
      drinkCount++;
    } else if (mealType == "dessert") {
      dessertCount++;
    }
  }

  // Decrement counter
  void decrementCounter(String mealType) {
    if (mealType == "main" && mainCount > 0) {
      mainCount--;
    } else if (mealType == "side" && sideCount > 0) {
      sideCount--;
    } else if (mealType == "drink" && drinkCount > 0) {
      drinkCount--;
    } else if (mealType == "dessert" && dessertCount > 0) {
      dessertCount--;
    }
  }

  // Get the current counter value for a meal type
  int getCounter(String mealType) {
    if (mealType == "main") {
      return mainCount;
    } else if (mealType == "side") {
      return sideCount;
    } else if (mealType == "drink") {
      return drinkCount;
    } else if (mealType == "dessert") {
      return dessertCount;
    }
    return 0;
  }
}