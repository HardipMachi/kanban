import 'package:flutter/material.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/di/notifiers/kanban_notifiers.dart';
import 'package:kanban/generated/s.dart';
import 'toast_util.dart';

Future<void> showAddTaskDialog(BuildContext context, KanbanNotifier notifier) async {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(S.of(context)!.addTask),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: InputDecoration(labelText: S.of(context)?.textFieldTitle)),
          TextField(controller: descController, decoration: InputDecoration(labelText: S.of(context)?.textFieldDesc)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(S.of(context)!.cancelTextButton)),
        TextButton(
          onPressed: () async {
            final title = titleController.text.trim();
            final desc = descController.text.trim();
            if (title.isEmpty) return;

            final newTask = TaskEntity(
              id: '',
              title: title,
              description: desc,
              status: S.of(context)!.todo,
              userId: '',
            );

            await notifier.addTask(newTask);
            if (context.mounted) showToast(context, S.of(context)!.taskAddSuccess, isSuccess: true);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(S.of(context)!.add),
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
      title: Text(S.of(context)!.editTask),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: InputDecoration(labelText: S.of(context)!.textFieldTitle)),
          TextField(controller: descController, decoration: InputDecoration(labelText: S.of(context)!.textFieldDesc)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(S.of(context)!.cancelTextButton)),
        TextButton(
          onPressed: () async {
            final newTitle = titleController.text.trim();
            final newDesc = descController.text.trim();
            if (newTitle.isEmpty) return;

            await notifier.updateTask(task, newTitle, newDesc);
            if (context.mounted) showToast(context, S.of(context)!.taskEditSuccess, isSuccess: true);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(S.of(context)!.update),
        ),
      ],
    ),
  );
}
