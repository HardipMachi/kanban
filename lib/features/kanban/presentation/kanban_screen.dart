import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../app/routes/app_router.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import '../data/model/task_model.dart';

final kanbanTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  return FirebaseFirestore.instance
      .collection('tasks')
      .where('userId', isEqualTo: uid)
      .orderBy('createdAt')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
});

// Provider for notifier
final kanbanNotifierProvider = Provider<KanbanNotifier>((ref) => KanbanNotifier());

class KanbanNotifier {
  final _firestore = FirebaseFirestore.instance;

  Future<void> addTask(String title, String description,
      {String status = 'todo'}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('tasks').add({
      'title': title,
      'description': description,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': uid,
    });
  }

  Future<void> updateStatus(String taskId, String status) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': status,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}

class KanbanScreen extends ConsumerWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(kanbanTasksProvider);
    final notifier = ref.read(kanbanNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              appRouter.go('/login');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, notifier),
        child: const Icon(Icons.add),
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final todo = tasks.where((t) => t.status == 'todo').toList();
          final inProgress = tasks.where((t) => t.status == 'inProgress').toList();
          final completed = tasks.where((t) => t.status == 'completed').toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildColumn(context, notifier, 'To Do', 'todo', todo, Colors.blue.shade100),
                  const SizedBox(width: 12),
                  buildColumn(context, notifier, 'In Progress', 'inProgress', inProgress, Colors.orange.shade100),
                  const SizedBox(width: 12),
                  buildColumn(context, notifier, 'Completed', 'completed', completed, Colors.green.shade100),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  // Function to show Add Task dialog
  void _showAddTaskDialog(BuildContext context, KanbanNotifier notifier) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final desc = descController.text.trim();
              if (title.isEmpty) return;

              await notifier.addTask(title, desc);

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task added successfully!'), backgroundColor: Colors.green),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Build each Kanban column
  Widget buildColumn(
      BuildContext context,
      KanbanNotifier notifier,
      String title,
      String status,
      List<TaskModel> tasks,
      Color headerColor) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      // margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 3)),
        ],
      ),
      child: DragTarget<TaskModel>(
        onAccept: (task) => notifier.updateStatus(task.id, status),
        builder: (context, candidateData, rejectedData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const SizedBox(height: 8),
              // Expanded ListView
              SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: tasks.isEmpty
                    ? const Center(child: Text('No tasks yet', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return LongPressDraggable<TaskModel>(
                      data: task,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.title),
                          ),
                        ),
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration: task.status == 'completed' ? TextDecoration.lineThrough : null,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () async {
                              await notifier.deleteTask(task.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Task deleted'), backgroundColor: Colors.red),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
