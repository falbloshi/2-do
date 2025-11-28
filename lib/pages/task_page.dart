import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  List<List<String>> notesData = [
    ['Shopping List', 'Milk', 'Eggs', 'Bread', 'Cheese'],
    [
      'Meeting Minutes',
      'Discussed Q3 results.',
      'Agreed on new marketing strategy.',
      'Follow-up: Contact vendor X.',
    ],
    ['Travel Checklist', 'Passport', 'Tickets', 'Chargers'],
  ];

  void deleteNote(int index) {
    String deletedTitle = notesData[index][0];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 800),
        content: Text('Deleted "$deletedTitle"'),
      ),
    );

    setState(() {
      notesData.removeAt(index);
    });
  }

  void deleteItem(int noteIndex, int itemIndex) {
    String deletedItem = notesData[noteIndex][itemIndex + 1];
    String noteTitle = notesData[noteIndex][0];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 800),
        content: Text('Removed "$deletedItem" from "$noteTitle"'),
      ),
    );

    setState(() {
      notesData[noteIndex].removeAt(itemIndex + 1);

      if (notesData[noteIndex].length == 1) {
        notesData.removeAt(noteIndex);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 800),
            content: Text('Removed "$noteTitle" — emptied tasks!'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To Dos'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notesData.length,
        itemBuilder: (context, index) {
          List<String> notesList = notesData[index];
          String title = notesList[0];
          List<String> items = notesList.sublist(1);

          return NoteCard(
            title: title,
            items: items,
            noteIndex: index,
            onDeleteNote: () => deleteNote(index),
            onDeleteItem: (index, itemIndex) => deleteItem(index, itemIndex),
          );
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final int noteIndex;
  final VoidCallback onDeleteNote;
  final Function(int noteIndex, int itemIndex) onDeleteItem;

  const NoteCard({
    super.key,
    required this.noteIndex,
    required this.title,
    required this.items,
    required this.onDeleteNote,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: const Icon(Icons.bookmark_outlined, color: Colors.amberAccent),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.pinkAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Note'),
                    content: Text('Delete "$title"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onDeleteNote();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: items.map((item) {
          return ListTile(
            leading: const Icon(Icons.circle, size: 8),
            title: Text(item),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => onDeleteItem(noteIndex, items.indexOf(item)),
            ),
            dense: true,
          );
        }).toList(),
      ),
    );
  }
}
