import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingListModel extends ChangeNotifier {
  final Box _shoppingListBox = Hive.box('shoppingListBox');

  // Method to load tasks from Hive
  List<Map<String, dynamic>> get tasks {
    List<Map<String, dynamic>> taskList = [];
    for (int i = 0; i < _shoppingListBox.length; i++) {
      taskList.add(_shoppingListBox.getAt(i));
    }
    return taskList;
  }

  // Add a new task
  void addTask(String taskName) {
    final task = {'name': taskName, 'completed': false};
    _shoppingListBox.add(task);
    notifyListeners(); // Notify listeners after adding a task
  }

  // Delete a task by index
  void deleteTask(int index) {
    _shoppingListBox.deleteAt(index);
    notifyListeners(); // Notify listeners after deleting a task
  }

  // Toggle the completion status of a task
  void toggleTask(int index) {
    final task = _shoppingListBox.getAt(index);
    task['completed'] = !task['completed'];
    _shoppingListBox.putAt(index, task); // Update task in Hive
    notifyListeners(); // Notify listeners after toggling a task
  }
}
