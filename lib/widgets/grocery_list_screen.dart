import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/data/dummy_items.dart';
import 'package:flutter_shopping_app/widgets/grocery_list_item.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Groceries")),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: groceryItems.length,
          itemBuilder: (context, position) {
            return GroceryListItem(groceryItem:groceryItems[position]);
            
          }),
    );
  }
}
