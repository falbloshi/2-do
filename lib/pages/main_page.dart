import 'package:flutter/material.dart';

Map<String, List<String>> notesData = {
  'Shopping List': ['Milk', 'Eggs', 'Bread', 'Cheese'],
  'Meeting Minutes': [
    'Discussed Q3 results.',
    'Agreed on new marketing strategy.',
    'Follow-up: Contact vendor X.',
  ],
  'Travel Checklist': ['Passport', 'Tickets', 'Chargers'],
};

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          'To Do',
          style: TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: ToDoListView(),
    );
  }
}

class ToDoListView extends StatefulWidget {
  const ToDoListView({super.key});

  @override
  State<ToDoListView> createState() => _ToDoListViewState();
}

class _ToDoListViewState extends State<ToDoListView> {
  bool isDone = false;

  void strikeOff() {
    setState(() {
      isDone = !isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = isDone ? Colors.grey : Colors.black;
    final TextDecoration textDecoration = isDone
        ? TextDecoration.lineThrough
        : TextDecoration.none;
    final FontStyle fontStyle = isDone ? FontStyle.italic : FontStyle.normal;

    return Center(
      child: GestureDetector(
        onTap: strikeOff,
        child: Text(
          'Hello',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textColor,
            decoration: textDecoration,
            fontStyle: fontStyle,
          ),
        ),
      ),
    );
  }
}
