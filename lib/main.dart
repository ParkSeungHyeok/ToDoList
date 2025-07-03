import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoItem {
  String task;
  bool isDone;

  ToDoItem({required this.task, this.isDone = false});

  Map<String, dynamic> toJson() => {'task': task, 'isDone': isDone};

  // JSON에서 객체로 변환
  factory ToDoItem.fromJson(Map<String, dynamic> json) =>
      ToDoItem(task: json['task'], isDone: json['isDone']);
}

void main() {
  runApp(const MySecondApp());
}

class MySecondApp extends StatelessWidget {
  const MySecondApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'To Do List',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: const ToDoScreen(),
  );
}

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  TextEditingController inputTextController = TextEditingController();
  final List<ToDoItem> toDoList = [];

  @override
  void initState() {
    super.initState();
    loadToDoList();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('To Do List')),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [inputToDoItem(), SizedBox(height: 8), outputToDoList()],
      ),
    ),
  );

  Widget inputToDoItem() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: inputTextController,
            decoration: InputDecoration(
              hintText: '할 일을 입력하세요',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(onPressed: _addTodo, child: Text('추가')),
      ],
    ),
  );

  void _addTodo() {
    final text = inputTextController.text;
    if (text.isEmpty) return;

    setState(() {
      toDoList.add(ToDoItem(task: text));
    });

    inputTextController.clear();
    saveToDoList();
  }

  Widget outputToDoList() => Expanded(
    child: ListView.builder(
      itemCount: toDoList.length,
      itemBuilder: (context, index) => getFrameToDoList(index),
    ),
  );

  Widget getFrameToDoList(int i) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      child: ListTile(
        leading: Checkbox(
          value: toDoList[i].isDone,
          onChanged: (checked) {
            setState(() {
              toDoList[i].isDone = checked!;
            });
            saveToDoList();
          },
        ),
        title: Text(
          toDoList[i].task,
          style: TextStyle(
            decoration: toDoList[i].isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            setState(() {
              toDoList.removeAt(i);
            });
            saveToDoList();
          },
        ),
      ),
    ),
  );

  Future<void> saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      toDoList.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('todo_list', jsonString);
  }

  Future<void> loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('todo_list');

    if (jsonString == null) return;

    final List<dynamic> jsonList = jsonDecode(jsonString);
    final List<ToDoItem> loadedList = jsonList
        .map((itemJson) => ToDoItem.fromJson(itemJson))
        .toList();

    setState(() {
      toDoList.addAll(loadedList);
    });
  }
}
