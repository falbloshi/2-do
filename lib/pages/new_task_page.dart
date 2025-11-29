import 'package:flutter/material.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do Editor'),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const NewTaskPage(),
                ),
              );
            },
            icon: const Icon(Icons.save_as_rounded, size: 25),
            label: Text('Save', style: TextStyle(fontSize: 20)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(255, 255, 255, 0.08),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
