import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class DraftManager {
  static String? draftTitle;
  static String? draftDesc;
  static String? draftTasks;

  static void saveDraft(String title, String desc, String tasks) {
    draftTitle = title;
    draftDesc = desc;
    draftTasks = tasks;
  }

  static void clearDraft() {
    draftTitle = null;
    draftDesc = null;
    draftTasks = null;
  }
}

class NewTaskPage extends StatefulWidget {
  final int? taskIndex;

  const NewTaskPage({super.key, this.taskIndex});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final tasksController = TextEditingController();

  late final Box tasksBox = Hive.box('tasksBox');

  @override
  void initState() {
    super.initState();

    if (widget.taskIndex != null) {
      final list = (tasksBox.getAt(widget.taskIndex!) as List).cast<String>();

      titleController.text = list[0];
      descController.text = list[1];
      tasksController.text = list.sublist(2).join('\n');
    } else {
      titleController.text = DraftManager.draftTitle ?? '';
      descController.text = DraftManager.draftDesc ?? '';
      tasksController.text = DraftManager.draftTasks ?? '';
    }
  }

  void showSnack(String msg, {Colors? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 400,
        backgroundColor: Colors.green[600],
        duration: Duration(milliseconds: 2500),
        content: Center(
          child: Text(msg, style: TextStyle(color: Colors.yellow[100])),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (widget.taskIndex == null) {
      DraftManager.saveDraft(
        titleController.text,
        descController.text,
        tasksController.text,
      );
    }
    super.dispose();
  }

  void validateAndSaveForm() {
    final isEditing = widget.taskIndex != null;

    if (titleController.text.isEmpty) {
      return showSnack('Title is empty');
    }
    if (tasksController.text.isEmpty) {
      return showSnack('To do list is empty');
    }

    final tasks = tasksController.text
        .split('\n')
        .where((t) => t.trim().isNotEmpty)
        .toList();

    final emptyDesc = descController.text.trim().isEmpty
        ? ''
        : descController.text.trim();

    final newNote = <String>[
      titleController.text.trim(),
      emptyDesc,
      ...tasks.map((e) => e.toString().trim()),
    ];

    if (isEditing) {
      tasksBox.putAt(widget.taskIndex!, newNote);
      showSnack('"${titleController.text}" has been updated!');
    } else {
      tasksBox.add(newNote);
      showSnack('"${titleController.text}" has been saved!');
      DraftManager.clearDraft();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskIndex != null;
    final appColor = isEditing ? Colors.green[400] : Colors.blueAccent;
    final appTitle = isEditing
        ? 'Editing ${titleController.text}'
        : 'New Tasks';

    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle, style: TextStyle(fontSize: 18)),
        backgroundColor: appColor,
        actions: [
          TextButton.icon(
            onPressed: validateAndSaveForm,
            icon: const Icon(Icons.save_as_rounded, size: 24),
            label: Text('Save', style: TextStyle(fontSize: 16)),
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
        descController: descController,
        tasksController: tasksController,
      ),

      floatingActionButton: (widget.taskIndex == null && !isKeyboardOpen)
          ? FloatingActionButton(
              mini: true,
              onPressed: () {
                setState(() {
                  titleController.clear();
                  descController.clear();
                  tasksController.clear();
                  DraftManager.clearDraft();
                });
                showSnack('Draft cleared');
              },
              backgroundColor: Colors.red[400],
              tooltip: 'Clear Draft',
              child: const Icon(Icons.clear_all, size: 24),
            )
          : null,
    );
  }
}

class EntryForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descController;
  final TextEditingController tasksController;

  const EntryForm({
    super.key,
    required this.titleController,
    required this.descController,
    required this.tasksController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),

            SizedBox(height: 28),

            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description (Optional)'),
            ),

            SizedBox(height: 56),

            TextFormField(
              controller: tasksController,
              minLines: 3,
              maxLines: null,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Write your to dos here. \n- \n- \n- ',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
