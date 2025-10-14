import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/notifiers/kanban_notifiers.dart';
import 'toast_util.dart';

Future<void> showAddTaskDialog(BuildContext context, KanbanNotifier notifier) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            final title = titleController.text.trim();
            final desc = descController.text.trim();
            if (title.isEmpty) return;

            final newTask = TaskEntity(
              id: '',
              title: title,
              description: desc,
              status: 'todo',
              userId: '',
            );

            await notifier.addTask(newTask);
            if (context.mounted) showToast(context, "Task added successfully", isSuccess: true);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    ),
  );
}

Future<void> showEditTaskDialog(BuildContext context, KanbanNotifier notifier, TaskEntity task) async {
  final titleController = TextEditingController(text: task.title);
  final descController = TextEditingController(text: task.description);

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            final newTitle = titleController.text.trim();
            final newDesc = descController.text.trim();
            if (newTitle.isEmpty) return;

            await notifier.updateTask(task, newTitle, newDesc);
            if (context.mounted) showToast(context, "Task edited successfully", isSuccess: true);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}
