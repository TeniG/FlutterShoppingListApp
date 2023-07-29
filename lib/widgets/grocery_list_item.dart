import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({super.key, required this.groceryItem});

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.square, color: groceryItem.category.color),
        const SizedBox(width: 18, height: 40,),
        Expanded(
          child: Text(
            groceryItem.name,
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        Text(
          textAlign: TextAlign.end,
          groceryItem.quantity.toString(),
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        )
      ],
    );
  }
}
