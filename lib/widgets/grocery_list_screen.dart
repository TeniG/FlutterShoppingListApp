import 'dart:convert';

import 'package:flutter_shopping_app/data/categories.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/models/grocery_item.dart';
import 'package:flutter_shopping_app/widgets/new_item_screen.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  var _groceryItems = [];

  void _loadItem() async {
    final Uri url = Uri.https(
      'fluttershoppingapp-42261-default-rtdb.firebaseio.com',
      'shopping-list.json');

     final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<GroceryItem> _loadedItems = [];

      final Map<String, dynamic> resData =
          json.decode(response.body);
    

      for (final item in resData.entries) {

        final _category = categories.entries.firstWhere((catItem) => catItem.value.title == item.value['category']);

        _loadedItems.add(
          GroceryItem(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: _category.value),
        );
      }
      // final groceryItemListFromServer = ShoppingListApiCall().getGroceryItems();
      setState(() {
        _groceryItems = _loadedItems;
      });
    }
  }

  void _addItem() async {
    final newGroceryItemAdded = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const NewItemScreen()),
    );

    if (newGroceryItemAdded == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newGroceryItemAdded);
    });
  }

  void _removeItem(GroceryItem groceryItem) {
    _groceryItems.remove(groceryItem);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("No Items in your Groceries.."));


    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
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
        },
      );
    }

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
        body: content);
  }
}
