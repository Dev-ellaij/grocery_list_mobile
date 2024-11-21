// lib/data/database.dart

import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  late Box _box;
  List<List<dynamic>> toDoList = [];

  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('mybox');
    loadData();
  }

  void createInitialData() {
    toDoList = [
      ['Buy groceries', false],
      ['Walk the dog', false],
      ['Read a book', false],
    ];
    updateDataBase();
  }

  void loadData() {
    toDoList = _box.get('TODOLIST', defaultValue: []);
  }

  void updateDataBase() {
    _box.put('TODOLIST', toDoList);
  }

  void addTask(String task) {
    toDoList.add([task, false]);
    updateDataBase();
  }

  void editTask(int index, String newTaskName) {
    toDoList[index][0] = newTaskName;
    updateDataBase();
  }

  void deleteTask(int index) {
    toDoList.removeAt(index);
    updateDataBase();
  }

  void toggleTaskCompletion(int index) {
    toDoList[index][1] = !toDoList[index][1];
    updateDataBase();
  }
}
