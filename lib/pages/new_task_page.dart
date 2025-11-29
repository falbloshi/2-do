import 'package:flutter/material.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final titleController = TextEditingController();
  final taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do Editor'),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton.icon(
            onPressed: () {
              final newNote = taskController.text.split('\n');
              newNote.insert(0, titleController.text);
              print(newNote);
            },
            icon: const Icon(Icons.save_as_rounded, size: 25),
            label: Text('Save', style: TextStyle(fontSize: 20)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white10,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: EntryForm(
        titleController: titleController,
        taskController: taskController,
      ),
    );
  }
}

class EntryForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController taskController;

  const EntryForm({
    super.key,
    required this.titleController,
    required this.taskController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 48),
          TextFormField(
            controller: taskController,
            minLines: 3,
            maxLines: null,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Write your tasks here. \n1.\n2.\n3.',
              hintStyle: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey, // change this to whatever fits
              ),
            ),
          ),
        ],
      ),
    );
  }
}
