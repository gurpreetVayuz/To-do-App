import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_application/model/to_do_model.dart';
import 'package:todo_application/screens/todo_home_page.dart';
import 'package:todo_application/service/todo_service.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoModelAdapter());
  TodoService().openBox;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      home: Todo_Home_Page(),
    );
  }
}
