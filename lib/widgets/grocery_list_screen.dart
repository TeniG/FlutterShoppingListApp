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
  var _isLoading = true;
  String? _error;

  void _loadItem() async {
    final Uri url = Uri.https(
        'fluttershoppingapp-42261-default-rtdb.firebaseio.com',
        'shopping-list.json');

    final response = await http.get(url);
    print(response.statusCode);

    if (response.statusCode > 400) {
      setState(() {
        _error = "Error loading the data.Please try agian later.";
      });
    }

    if (response.statusCode == 200) {
      _error = null;
      final List<GroceryItem> _loadedItems = [];

      final Map<String, dynamic> resData = json.decode(response.body);

      for (final item in resData.entries) {
        final _category = categories.entries.firstWhere(
            (catItem) => catItem.value.title == item.value['category']);

        _loadedItems.add(
          GroceryItem(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: _category.value),
        );
        if (response.body == 'null') {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      // final groceryItemListFromServer = ShoppingListApiCall().getGroceryItems();
      setState(() {
        _groceryItems = _loadedItems;
        _isLoading = true;
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

  void _removeItem(GroceryItem groceryItem) async {

    var index = _groceryItems.indexOf(groceryItem);
    setState(() {
      _groceryItems.remove(groceryItem);
    });



    final Uri url = Uri.https(
        'flluttershoppingapp-42261-default-rtdb.firebaseio.com',
        'shopping-list/${groceryItem.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index,groceryItem);
        SnackBar snackBar = const SnackBar(content: Text("Couldn't delete the item"),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("No Items in your Groceries.."));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

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

    if (_error != null) {
      content = Center(child: Text(_error!));
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
