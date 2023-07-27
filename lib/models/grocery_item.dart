
import 'package:flutter_shopping_app/models/category.dart';

class GroceryItem {
  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category
  });

  final String id;
  final String name;
  final int quantity;
  final Category category;
}