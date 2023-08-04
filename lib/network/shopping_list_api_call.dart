import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_shopping_app/models/grocery_item.dart';

class ShoppingListApiCall {
  final Uri url = Uri.https(
      'fluttershoppingapp-42261-default-rtdb.firebaseio.com',
      'shopping-list.json');

  saveGroceryItem(GroceryItem groceryItem) {
    final response = http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': groceryItem.name,
          'quantity': groceryItem.quantity,
          'category': groceryItem.category.title
        }));
    response.then((value) {
      if (value.statusCode == 200 || value.statusCode == 201) {
        return ("GroceryItem saved successfully on server...!!");
      }
    }).onError((error, stackTrace) {
      return ("GrocerySaveItem : error : ${error.toString()}");
    });
  }

  // Future<List<GroceryItem>> getGroceryItems() async {
  //   final response = await http.get(url, headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   });

  //   if (response.statusCode == 200) {
  //     final List<GroceryItem> groceryItemList = [];

  //     final Map<String, Map<String, dynamic>> resData =
  //         json.decode(response.body);
  //     print(resData);

  //     for (final item in resData.entries) {
  //       groceryItemList.add(
  //         GroceryItem(
  //             id: item.key,
  //             name: item.value['name'],
  //             quantity: item.value['quantity'],
  //             category: item.value['category']),
  //       );
  //     }

  //     return groceryItemList;
  //   } else {
  //     throw Exception('Failed to get Items');
  //   }
  // }
}
