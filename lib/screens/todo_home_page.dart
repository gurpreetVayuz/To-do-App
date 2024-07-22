import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/Strings/string.dart';
import 'package:todo_application/model/to_do_model.dart';
import 'package:todo_application/service/todo_service.dart';

class Todo_Home_Page extends StatefulWidget {
  const Todo_Home_Page({super.key});

  @override
  State<Todo_Home_Page> createState() => _Todo_Home_PageState();
}

class _Todo_Home_PageState extends State<Todo_Home_Page> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  final TodoService _todoService = TodoService();
  List<ToDoModel>? _toDoModel = [];
  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    _toDoModel = await _todoService.getTodos();
    // _toDoModel?.sort((a, b) => a.datecreated!.compareTo(b.datecreated!));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 141, 140, 217),
        title: const Text(Strings.allTasks),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialogue();
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
            itemCount: _toDoModel?.length,
            itemBuilder: (context, index) {
              final todo = _toDoModel?[index];
              var date = todo?.datecreated;
              var formattedDate = DateFormat('dd-MM-yyyy').format(date!);
              return Card(
                elevation: 02,
                child: ListTile(
                  onTap: () {
                    _showEditDialogue(todo!, index);
                  },
                  title: Text("${todo?.title}"),
                  subtitle: Text("${todo?.description}"),
                  leading: Checkbox(
                      value: todo?.completed,
                      onChanged: (value) {
                        setState(() {
                          todo?.completed = value!;
                          _todoService.updateTodo(index, todo!);
                        });
                      }),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        onTap: () async {
                          await _todoService.deleteTodo(index);
                          _titleController.clear();
                          _descriptionController.clear();
                          _selectedDate = DateTime.now();
                          _loadTodos();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> _showAddDialogue() async {
    DateTime? tempSelectedDate = _selectedDate;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                            hintText: (Strings.title),
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 149, 149, 149))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: (Strings.description),
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 149, 149, 149))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () async {
                          DateTime? pickedDate = await _pickDate(context);
                          if (pickedDate != null) {
                            setState(() {
                              tempSelectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          tempSelectedDate == null
                              ? Strings.selectDate
                              : DateFormat('dd-MM-yyyy')
                                  .format(tempSelectedDate!),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 149, 149, 149)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(Strings.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _selectedDate = tempSelectedDate;
                  });
                  final newTodo = ToDoModel(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      datecreated: tempSelectedDate,
                      completed: false);
                  if (_selectedDate != null || tempSelectedDate != null) {
                   await _todoService.addTodo(newTodo);
                  _titleController.clear();
                  _descriptionController.clear();

                  Navigator.pop(context);
                  _selectedDate = null;
                  _loadTodos();
                  }
                   final snackBar = SnackBar(
                      content: Text('Please select date !'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    
                  
                },
                child: const Text(Strings.add),
              ),
            ],
          );
        });
  }

  Future<void> _showEditDialogue(ToDoModel toDoModel, int index) async {
    _titleController.text = toDoModel.title;
    _descriptionController.text = toDoModel.description;
    _selectedDate = toDoModel.datecreated;

    DateTime? tempSelectedDate = _selectedDate;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(Strings.editTask),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                            hintText: (Strings.title),
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 149, 149, 149))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: (Strings.description),
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 149, 149, 149))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton(
                        onPressed: () async {
                          DateTime? pickedDate = await _pickDate(context);
                          if (pickedDate != null) {
                            setState(() {
                              tempSelectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          tempSelectedDate == null
                              ? Strings.selectDate
                              : DateFormat('dd-MM-yyyy')
                                  .format(tempSelectedDate!),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 149, 149, 149)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(Strings.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  toDoModel.title = _titleController.text;
                  toDoModel.description = _descriptionController.text;
                  toDoModel.datecreated = tempSelectedDate;
                  if (toDoModel.completed == true) {
                    toDoModel.completed = false;
                  }

                  await _todoService.updateTodo(index, toDoModel);

                  setState(() {
                    _selectedDate = tempSelectedDate;
                  });

                  _titleController.clear();
                  _descriptionController.clear();
                  _selectedDate = DateTime.now();

                  Navigator.pop(context);
                  _loadTodos();
                },
                child: const Text(Strings.update),
              ),
            ],
          );
        });
  }

  Future<DateTime?> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }
}
