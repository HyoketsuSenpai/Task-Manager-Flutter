import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Task.dart';

class TaskManager extends StatefulWidget {
  @override
  _TaskManager createState() => _TaskManager();
}

class _TaskManager extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Column(
        children: [
          Expanded(
            child: Tasks(), // Give ListView space to expand
          ),
          Padding(padding: const EdgeInsets.all(8.0), child: AddNewTask()),
        ],
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var tasks = <Task>[];

  void AddTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void DeleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }

  void UpdateComplete(Task task, bool completed) {
    task.completed = completed;
    notifyListeners();
  }
}

class Tasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var tasks = appState.tasks;

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          leading: Checkbox(
            value: task.completed,
            onChanged: (bool? newBool) {
              appState.UpdateComplete(task, newBool ?? false);
            },
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.completed ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              appState.DeleteTask(task);
            },
          ),
        );
      },
    );
  }
}

class AddNewTask extends StatefulWidget {
  // Changed from Stateless to Stateful
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.read<MyAppState>();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter task'),
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              appState.AddTask(Task(text));
              controller.clear();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
