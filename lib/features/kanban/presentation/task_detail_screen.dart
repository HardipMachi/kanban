// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../data/model/task_model.dart';
// import 'providers/kanban_provider.dart';
//
// class TaskDetailScreen extends ConsumerStatefulWidget {
//   final TaskModel task;
//   const TaskDetailScreen({super.key, required this.task});
//
//   @override
//   ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
// }
//
// class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
//   late TextEditingController titleController;
//   late TextEditingController descController;
//
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     titleController = TextEditingController(text: widget.task.title);
//     descController = TextEditingController(text: widget.task.description);
//   }
//
//   @override
//   void dispose() {
//     titleController.dispose();
//     descController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final notifier = ref.read(kanbanNotifierProvider.notifier);
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Task Details')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(labelText: 'Title'),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: descController,
//               decoration: const InputDecoration(labelText: 'Description'),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 20),
//
//             // ✅ Update button
//             ElevatedButton.icon(
//               icon: const Icon(Icons.update),
//               label: const Text('Update'),
//               onPressed: _isLoading
//                   ? null
//                   : () async {
//                 FocusScope.of(context).unfocus();
//                 final newTitle = titleController.text.trim();
//                 final newDesc = descController.text.trim();
//
//                 if (newTitle.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Title cannot be empty ❌'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                   return;
//                 }
//
//                 setState(() => _isLoading = true);
//
//                 try {
//                   await notifier.updateTask(
//                     widget.task.copyWith(
//                       title: newTitle,
//                       description: newDesc,
//                     ),
//                   );
//
//                   if (mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Task updated successfully ✅'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                     Navigator.pop(context); // back to Kanban
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to update: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 } finally {
//                   if (mounted) setState(() => _isLoading = false);
//                 }
//               },
//             ),
//
//             const SizedBox(height: 10),
//
//             // ✅ Delete button
//             ElevatedButton.icon(
//               icon: const Icon(Icons.delete_forever),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               label: const Text('Delete'),
//               onPressed: _isLoading
//                   ? null
//                   : () async {
//                 final confirm = await showDialog<bool>(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Delete Task'),
//                     content: const Text(
//                         'Are you sure you want to delete this task? This cannot be undone.'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, false),
//                         child: const Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () => Navigator.pop(context, true),
//                         child: const Text('Delete',
//                             style: TextStyle(color: Colors.red)),
//                       ),
//                     ],
//                   ),
//                 );
//
//                 if (confirm != true) return;
//
//                 setState(() => _isLoading = true);
//
//                 try {
//                   await notifier.deleteTask(widget.task.id);
//                   if (mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Task deleted successfully 🗑️'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                     Navigator.pop(context);
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Failed to delete: $e'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 } finally {
//                   if (mounted) setState(() => _isLoading = false);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
