import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/todo_model.dart';
import 'package:intl/intl.dart';

class ToDoAddProvider extends ChangeNotifier {
  static const String name = 'user';
  final List<TodoModel> _todoList = <TodoModel>[];
  late GetStorage box;
  final TextEditingController todoController = TextEditingController();

  List<TodoModel> get todoList => _todoList;

  ToDoAddProvider({required this.box});

  Future getList() async {
    var keyList = box.getKeys();
    keyList = List.from(keyList);
    for (var i = 0; i < keyList.length; i++) {
      _todoList.add(TodoModel.fromJson(box.read(keyList[i])));
    }
    _todoList.sort((a, b) => a.isChecked!.compareTo(b.isChecked!));
    notifyListeners();
  }

  void add() async {
    DateTime time = DateTime.now();
    String timeFormat = DateFormat('dd/MM/yyyy hh:mm').format(time);
    box.write(time.toString(), TodoModel(id: time.millisecondsSinceEpoch, name: todoController.text, isChecked: 0, createdAt: timeFormat).toJson());
    _todoList.insert(0, TodoModel(id: time.millisecondsSinceEpoch, name: todoController.text, isChecked: 0, createdAt: timeFormat));
    notifyListeners();
  }

  void checked(id, name, createdAt) {
    if (_todoList.where((element) => element.id == id).first.isChecked == 0) {
      _todoList.where((element) => element.id == id).first.isChecked = 1;
    } else {
      _todoList.where((element) => element.id == id).first.isChecked = 0;
    }
    box.erase();
    _todoList.forEach((element) => {box.write(element.id.toString(), TodoModel(id: element.id, name: element.name, isChecked: element.isChecked, createdAt: element.createdAt))});
    _todoList.sort((a, b) => a.isChecked!.compareTo(b.isChecked!));
    notifyListeners();
  }

  void remove(id, name, isChecked, createdAt) {
    _todoList.removeWhere((element) => element.id == id);
    // box.remove(id.toString());
    box.erase();
    _todoList.forEach((element) => {box.write(element.id.toString(), TodoModel(id: element.id, name: element.name, isChecked: element.isChecked, createdAt: element.createdAt))});
    notifyListeners();
  }
}

// class TodoModel {
//   int id;
//   String todo;
//   bool? isChecked;

//   TodoModel({required this.id, required this.todo, required this.isChecked});
// }
