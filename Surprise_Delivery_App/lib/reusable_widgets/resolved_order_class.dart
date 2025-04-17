class ResolvedMeal
{
  late List<String> mainMeals = List<String>.empty(growable: true);
  late List<String> sideMeals = List<String>.empty(growable: true);
  late List<String> dessertMeals = List<String>.empty(growable: true);
  late List<String> drinks = List<String>.empty(growable: true);

  ResolvedMeal();
  ResolvedMeal.init(this.mainMeals, this.sideMeals, this.dessertMeals, this.drinks);
}

class ResolvedOrder
{
  late List<ResolvedMeal> meals = List<ResolvedMeal>.empty(growable: true);

  ResolvedOrder();
  ResolvedOrder.init(this.meals);

  ResolvedMeal add({List<String>? main,
            List<String>? side,
            List<String>? dessert,
            List<String>? drinks})
  {
    if (main != null && side != null && dessert != null && drinks != null){
      meals.add(ResolvedMeal.init(main, side, dessert, drinks));
    }
    else {
      meals.add(ResolvedMeal());
    }
    return meals.last;
  }
}