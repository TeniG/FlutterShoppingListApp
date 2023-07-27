import 'package:flutter_shopping_app/models/grocery_item.dart';
import 'package:flutter_shopping_app/models/category.dart';
import 'package:flutter_shopping_app/data/categories.dart';

final groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Biscuits',
      quantity: 1,
      category: categories[Categories.snacks]!),
];