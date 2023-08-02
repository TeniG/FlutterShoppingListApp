import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/data/dummy_items.dart';
import 'package:flutter_shopping_app/models/grocery_item.dart';
import 'package:flutter_shopping_app/widgets/new_item_screen.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  final _groceryItems = [];

  void _addItem() async {
    final newGroceryItem = await Navigator.of(context).push<GroceryItem>(
       MaterialPageRoute(builder: (ctx) => const NewItemScreen()),
    );

    if (newGroceryItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newGroceryItem);
    });
  }

  void _removeItem(GroceryItem groceryItem) {
    _groceryItems.remove(groceryItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Groceries"),
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: (_groceryItems.isNotEmpty)
            ? ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _groceryItems.length,
                itemBuilder: (context, position) {
                  // return GroceryListItem(groceryItem:groceryItems[position]);
                 return Dismissible(
                  key: ValueKey(_groceryItems[position].id),
                  onDismissed: (direction) => _removeItem(_groceryItems[position]),
                   child: ListTile(
                      title: Text(_groceryItems[position].name),
                      leading: Container(
                        height: 24,
                        width: 24,
                        color: _groceryItems[position].category.color,
                      ),
                      trailing: Text(_groceryItems[position].quantity.toString()),
                    ),
                 );
                })
            : const Center(child: Text("No Items in your Groceries..")));
  }
}
