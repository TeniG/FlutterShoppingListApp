import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/data/categories.dart';
import 'package:flutter_shopping_app/models/category.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewItemScreenState();
  }
}

class NewItemScreenState extends State<NewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          child: Column(children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text("Name", style: TextStyle(fontSize: 18)),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: "1",
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("Quantity", style: TextStyle(fontSize: 12)),
                    ),
                  ),
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
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
              TextButton(onPressed: () {}, child: const Text("Reset")),
              ElevatedButton(onPressed: () {}, child: const Text("Add Item"))
            ],)
          ]),
        ),
      ),
    );
  }
}
