import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/domain/todo.dart';

const String databaseName = "todo_app_db";

final mainProvider = ChangeNotifierProvider<MainModel>(
        (ref) => MainModel()..initDatabase()
);


class MainModel extends ChangeNotifier {
  List<Todo> todoList = [];

  TextEditingController addNameController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController editingController = TextEditingController();

  void initDatabase() async {
    await Hive.initFlutter();
    await Hive.openBox(databaseName);

    fetchAll();
  }

  void fetchAll() {

    todoList = [];

    Box box = Hive.box(databaseName);
    List getTodoList = box.get("todo") ?? [];

    if (getTodoList.isNotEmpty) {
      for (var todo in getTodoList) {
        todoList.add(Todo(todo["title"], todo["text"]));
      }
    }

    notifyListeners();
  }

  void updateDatabase() {
    List<Map> putTodoList = [];

    if (todoList.isNotEmpty) {
      for (Todo todo in todoList) {
        putTodoList.add(todo.toMap());
      }
    }

    Box box = Hive.box(databaseName);
    box.delete("todo");
    box.put("todo", putTodoList);
  }

  void addTodo(String title) {
    todoList.add(Todo(title, ""));

    updateDatabase();
    notifyListeners();
  }

  void deleteTodo(int index) {
    todoList.removeAt(index);

    updateDatabase();
    notifyListeners();
  }

  void editTodo(int index, String text) {
    todoList[index].text = text;

    updateDatabase();
    notifyListeners();
  }

  void renameTodo(int index, String title) {
    todoList[index].title = title;

    updateDatabase();
    notifyListeners();
  }

  void openTodo(int index) {
    nameController.text = todoList[index].title;
    editingController.text = todoList[index].text;

    notifyListeners();
  }
}