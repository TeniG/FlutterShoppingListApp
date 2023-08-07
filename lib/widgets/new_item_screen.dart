import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shopping_app/data/categories.dart';
import 'package:flutter_shopping_app/models/category.dart';
import 'package:flutter_shopping_app/models/grocery_item.dart';
import 'package:flutter_shopping_app/network/shopping_list_api_call.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewItemScreenState();
  }
}

class NewItemScreenState extends State<NewItemScreen> {

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  String _eneteredName = "";
  int _eneteredQuantity = 1;
  Category _selectedCategory = categories[Categories.fruit]!;

  void _resetForm() {
    _formKey.currentState?.reset();
  }

  void _saveItem() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //API Call
      // ShoppingListApiCall().saveGroceryItem(newGroceryItem);

      final Uri url = Uri.https(
          'fluttershoppingapp-42261-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': _eneteredName,
            'quantity': _eneteredQuantity,
            'category': _selectedCategory.title
          }));
      response.then((value) {
        if (value.statusCode == 200 || value.statusCode == 201) {
          final Map<String, dynamic> resData = json.decode(value.body);

          final newItemAdded = GroceryItem(
              id: resData['name'],
              name: _eneteredName,
              quantity: _eneteredQuantity,
              category: _selectedCategory);

          if (!context.mounted) {
            return;
          }
          Navigator.of(context).pop(newItemAdded);
        }
      }).onError((error, stackTrace) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              style: const TextStyle(fontSize: 18),
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text("Name", style: TextStyle(fontSize: 18)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 2) {
                  return "Name should be between 2 to 50 character";
                }
                return null;
              },
              onSaved: (newValue) {
                _eneteredName = newValue!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                      style: const TextStyle(fontSize: 18),
                      initialValue: _eneteredQuantity.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Quantity", style: TextStyle(fontSize: 18)),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! < 0) {
                          return "Entered quantity is not valid";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _eneteredQuantity = int.parse(newValue!);
                      }),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: DropdownButtonFormField(
                    items: [
                      for (final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              Icon(Icons.square, color: category.value.color),
                              const SizedBox(width: 6),
                              Text(category.value.title)
                            ],
                          ),
                        )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _resetForm,
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text("Add Item"),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
