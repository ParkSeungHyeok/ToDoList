import 'package:flutter/material.dart';

void main() {
  runApp(const MySecondApp());
}

class MySecondApp extends StatelessWidget {
  const MySecondApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const ToDoScreen());
  }
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() {
    return _ToDoScreenState();
  }
}

class _ToDoScreenState extends State<ToDoScreen> {
  TextEditingController inputTextController = TextEditingController();
  List<String> toDoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To Do List')),
      body: Column(children: [inputToDoItem(), outputToDoList()]),
    );
  }

  Widget inputToDoItem() {
    return Row(
      children: [
        Expanded(child: TextField(controller: inputTextController)),
        ElevatedButton(onPressed: _addTodo, child: Text('추가')),
      ],
    );
  }

  void _addTodo() {
    if (inputTextController.text.isEmpty) return;

    setState(() {
      toDoList.add(inputTextController.text);
    });

    inputTextController.clear();
  }

  Widget outputToDoList() {
    return Expanded(child: ListView(children: gettoDoListWidget()));
  }

  List<Widget> gettoDoListWidget() {
    List<Widget> toDoListWidget = [];
    for (int i = 0; i < toDoList.length; i++) {
      toDoListWidget.add(Text(toDoList[i]));
    }
    return toDoListWidget;
  }
}
