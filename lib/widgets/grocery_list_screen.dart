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
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _groceryItemList;

  @override
  void initState() {
    super.initState();
    _groceryItemList = _loadedItem();
  }

  Future<List<GroceryItem>> _loadedItem() async {
    final Uri url = Uri.https(
        'fluttershoppingapp-42261-default-rtdb.firebaseio.com',
        'shopping-list.json');

    final response = await http.get(url);

    print("respnse code: ${response.statusCode}");
    print("respnse body: ${response.body}");

    final Map<String, dynamic> resData = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw Exception("Failed to fetch grocery item. Please try again after sometime.");
    }

    if (response.body == 'null') {
      return [];
    }

    final List<GroceryItem> _loadedItems = [];
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
    }

    return _loadedItems;
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
        'fluttershoppingapp-42261-default-rtdb.firebaseio.com',
        'shopping-list/${groceryItem.id}.json');

    final response = await http.delete(url);
    print("delete item statusCode: ${response.statusCode}");

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, groceryItem);
        SnackBar snackBar = const SnackBar(
          content: Text("Couldn't delete the item"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
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
      body: FutureBuilder(
          future: _groceryItemList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            if (snapshot.data!.isEmpty) {
              return const Center(child: Text("No Items in your Groceries.."));
            }

            _groceryItems = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, position) {
                // return GroceryListItem(groceryItem:groceryItems[position]);
                return Dismissible(
                  key: ValueKey(snapshot.data![position].id),
                  onDismissed: (direction) =>
                      _removeItem(snapshot.data![position]),
                  child: ListTile(
                    title: Text(snapshot.data![position].name),
                    leading: Container(
                      height: 24,
                      width: 24,
                      color: snapshot.data![position].category.color,
                    ),
                    trailing: Text(snapshot.data![position].quantity.toString()),
                  ),
                );
              },
            );
          }),
    );
  }
}
