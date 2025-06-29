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
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To Do List')),
      body: Center(child: TextField('여기에 To Do가 들어갈 예정!')),
    );
  }
}
