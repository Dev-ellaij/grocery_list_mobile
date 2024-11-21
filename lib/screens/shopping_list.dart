// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:grocery_list_mobile/widgets/todo_tile.dart';
import 'package:provider/provider.dart';
import '../models/shopping_list_model.dart';

class ShoppingListPage extends StatelessWidget {
  // ignore: use_super_parameters
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingList = Provider.of<ShoppingListModel>(context);

    final _controller = TextEditingController();

    // Add a new task
    void _addTask() {
      if (_controller.text.isNotEmpty) {
        shoppingList.addTask(_controller.text);
        _controller.clear();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Input Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter an item...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: Consumer<ShoppingListModel>(
              builder: (context, shoppingList, child) {
                return ListView.builder(
                  itemCount: shoppingList.tasks.length,
                  itemBuilder: (context, index) {
                    final task = shoppingList.tasks[index];
                    return ToDoTile(
                      taskName: task['name'],
                      taskCompleted: task['completed'],
                      onChanged: (value) => shoppingList.toggleTask(index),
                      deleteFunction: (context) =>
                          shoppingList.deleteTask(index),
                      speakTask: () {},
                      fetchAISuggestion: () {},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
