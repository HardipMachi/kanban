import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/app/app_constants/app_Strings.dart';
import 'package:kanban/app/app_routes/app_route_names.dart';
import 'package:kanban/features/auth/presentation/di/auth_providers/auth-providers.dart';
import 'package:kanban/features/kanban/presentation/providers/kanban_provider.dart';
import 'package:kanban/generated/s.dart';
import '../../../../app/app_routes/app_router.dart';
import '../../../../core/providers/loading_provider.dart';
import '../../../../core/utils/dialogue_utils.dart';
import '../../../../core/utils/toast_util.dart';
import '../../domain/entities/task_entity.dart';
import '../notifiers/kanban_notifiers.dart';

class KanbanScreen extends ConsumerWidget {
  const KanbanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(kanbanTasksProvider);
    final notifier = ref.read(kanbanNotifierProvider);
    final isLoading = ref.watch(loadingProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(S.of(context)!.kanbanTitle),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final isLoading = ref.read(loadingProvider);
                  if (isLoading) return;

                  ref.read(loadingProvider.notifier).state = true;

                  try {
                    await ref.read(authNotifierProvider.notifier).logout();
                    ref.invalidate(kanbanTasksProvider);
                    ref.invalidate(kanbanNotifierProvider);

                    if (context.mounted) {
                      showToast(context, S.of(context)!.logout, isSuccess: true);
                      await Future.delayed(const Duration(milliseconds: 300));
                      appRouter.go(AppRouteNames.login);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showToast(context, "Logout failed: ${e.toString()}", isSuccess: false);
                    }
                  } finally {
                    ref.read(loadingProvider.notifier).state = false;
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showAddTaskDialog(context, notifier),
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
        ),
        if (isLoading)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget buildColumn(BuildContext context, KanbanNotifier notifier, String title, String status, List<TaskEntity> tasks, Color headerColor) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6, offset: const Offset(2, 3))],
      ),
      child: DragTarget<TaskEntity>(
        onAccept: (task) => notifier.updateStatus(task, status),
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
              Expanded(
                child: tasks.isEmpty
                    ? const Center(child: Text('No tasks yet', style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return LongPressDraggable<TaskEntity>(
                      data: task,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(padding: const EdgeInsets.all(8.0), child: Text(task.title)),
                        ),
                      ),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title,
                                  style: TextStyle(
                                      decoration: task.status == 'completed' ? TextDecoration.lineThrough : null,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(task.description,
                                  maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => showEditTaskDialog(context, notifier, task),
                                    icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                                    label: const Text('Edit', style: TextStyle(color: Colors.blue)),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: () async {
                                      await notifier.deleteTask(task);
                                      if (context.mounted) {
                                        showToast(context, S.of(context)!.taskDelete, isSuccess: true);
                                      }
                                    },
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                    label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              )
                            ],
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
