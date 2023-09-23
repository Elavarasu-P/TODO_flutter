import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List toDoList = [];
  final myBox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [
      ["Drink Water", false],
      ["Do Workout", false],
    ];
  }

  void loadData() {
    toDoList = myBox.get("TODOLIST");
  }

  void updateDataBase() {
    myBox.put("TODOLIST", toDoList);
  }
}
