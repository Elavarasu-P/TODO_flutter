import 'package:flutter/material.dart';
import 'package:todo/data/database.dart';
import 'package:todo/util/todo_tile.dart';
import 'package:todo/util/dialog_box.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'dart:js';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mybox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    if (mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    // TODO: implement initState
    super.initState();
  }

  final controller = TextEditingController();
  // List toDoList = [
  //   ["Drink Water", false],
  //   ["Do Workout", false],
  // ];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([controller.text, false]);
      controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    print("send");
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    // print("hello");
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade300,
      appBar: AppBar(
        title: Text('To Be Done'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange.shade600,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFuntion: (context) => deleteTask(index),
          );
        },
      ),
      // children: [
      // ToDoTile(
      //   taskName: "Code",
      //   taskCompleted: true,
      //   onChanged: (p0) {},
      // ),
      // ToDoTile(
      //   taskName: "Project",
      //   taskCompleted: false,
      //   onChanged: (p0) {},
      // ),
      // ],
    );
  }

}
