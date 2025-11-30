import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:two_do/pages/new_task_page.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Box get tasksBox => Hive.box('tasksBox');

  void deleteTaskList(int index) async {
    final task = tasksBox.getAt(index) as List;
    final deletedName = task[0];

    await Future.delayed(const Duration(milliseconds: 600));

    tasksBox.deleteAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 800),
        content: Text('Deleted "$deletedName"'),
      ),
    );
  }

  void deleteTask(int listIndex, int itemIndex) {
    final task = tasksBox.getAt(listIndex) as List;
    final removedItem = task[itemIndex + 2];
    final title = task[0];

    task.removeAt(itemIndex + 2);
    tasksBox.putAt(listIndex, task);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 800),
        content: Text('Removed "$removedItem" from "$title"'),
      ),
    );

    if (task.length == 2) {
      tasksBox.deleteAt(listIndex);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 800),
          content: Text('Removed "$title" — emptied tasks!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My To Dos', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.red,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NewTaskPage(taskIndex: null),
                ),
              );
            },
            icon: const Icon(Icons.add_rounded, size: 24),
            label: const Text('New Tasks', style: TextStyle(fontSize: 16)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white10,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: tasksBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No tasks yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final raw = (box.getAt(index) as List).cast<String>();

              final title = raw[0];
              final subtitle = raw[1];
              final tasks = raw.sublist(2);

              return NoteCard(
                taskListIndex: index,
                title: title,
                subtitle: subtitle,
                tasks: tasks,
                onDeleteTaskList: () => deleteTaskList(index),
                onDeleteTask: deleteTask,
              );
            },
          );
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> tasks;
  final int taskListIndex;
  final VoidCallback onDeleteTaskList;
  final Function(int listIndex, int itemIndex) onDeleteTask;

  const NoteCard({
    super.key,
    required this.taskListIndex,
    required this.title,
    required this.subtitle,
    required this.tasks,
    required this.onDeleteTaskList,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),

      elevation: 1,
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        initiallyExpanded: true,
        shape: const Border(),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.amber),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NewTaskPage(taskIndex: taskListIndex),
                  ),
                );
              },
            ),
            SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.pinkAccent,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
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
                          onDeleteTaskList();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),

        children: tasks.asMap().entries.map((entry) {
          final idx = entry.key;
          final task = entry.value;

          return Dismissible(
            key: UniqueKey(),
            background: Container(color: const Color(0xFFE65A7D)),
            onDismissed: (_) {
              onDeleteTask(taskListIndex, idx);
            },
            child: ListTile(
              leading: const Icon(Icons.circle, size: 8),
              title: Text(task),
              dense: true,
            ),
          );
        }).toList(),
      ),
    );
  }
}
