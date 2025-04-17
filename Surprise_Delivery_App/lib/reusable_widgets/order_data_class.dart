import 'meal_class.dart';

class OrderData
{
  late List<Meal> orderedMeals;
  late String cuisineSelection;
  late int paymentAmount;

  OrderData(this.orderedMeals, this.cuisineSelection, this.paymentAmount);
  OrderData.empty() : this([], "", 0);
  OrderData.init(order) : this(order, "", 0);
  OrderData.noPay(order, cuisine) : this(order, cuisine, 100);
}

// List of available cuisines
final List<String> cuisineOptions = [
  'American',
  'British',
  'Canadian',
  'Chinese',
  'Croatian',
  'Dutch',
  'Egyptian',
  'Filipino',
  'French',
  'Greek',
  'Indian',
  'Irish',
  'Italian',
  'Jamaican',
  'Japanese',
  'Kenyan',
  'Mexican',
  'Spanish',
  'Thai',
  'Random'
];