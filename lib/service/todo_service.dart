import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_application/model/to_do_model.dart';

class TodoService {
  Box<ToDoModel>? _todoBox;

  Future<void> openBox() async {
    _todoBox = await Hive.openBox<ToDoModel>('todo');
  }

  Future<void> closeBox() async {
    await _todoBox!.close();
  }

  Future<void> addTodo(ToDoModel toDoModel) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.add(toDoModel);
  }

  Future<List<ToDoModel>> getTodos() async {
    if (_todoBox == null) {
      await openBox();
    }
    return _todoBox!.values.toList();
  }

  Future<void> updateTodo(int index, ToDoModel toDoModel) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.putAt(index, toDoModel);
  }

  Future<void> deleteTodo(int index) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.deleteAt(index);
  }
}
