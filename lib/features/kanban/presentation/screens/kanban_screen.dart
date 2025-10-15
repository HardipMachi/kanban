import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/app/app_constants/app_Strings.dart';
import 'package:kanban/app/app_routes/app_route_names.dart';
import 'package:kanban/app/app_routes/app_router.dart';
import 'package:kanban/core/providers/loading_provider.dart';
import 'package:kanban/core/utils/dialogue_utils.dart';
import 'package:kanban/core/utils/toast_util.dart';
import 'package:kanban/features/auth/presentation/di/auth_providers/auth-providers.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/presentation/components/taskcard.dart';
import 'package:kanban/features/kanban/presentation/di/notifiers/kanban_notifiers.dart';
import 'package:kanban/features/kanban/presentation/di/providers/kanban_provider.dart';
import 'package:kanban/generated/s.dart';

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
                      showToast(context, "${AppStrings.logoutFailed} ${e.toString()}", isSuccess: false);
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
              final todo = tasks.where((t) => t.status == AppStrings.todo).toList();
              final inProgress = tasks.where((t) => t.status == AppStrings.inProgress).toList();
              final completed = tasks.where((t) => t.status == AppStrings.completed).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildColumn(context, notifier, AppStrings.todoColumnTitle, AppStrings.todo, todo, Colors.blue.shade100),
                      const SizedBox(width: 12),
                      buildColumn(context, notifier, AppStrings.inProgressColumnTitle, AppStrings.inProgress, inProgress, Colors.orange.shade100),
                      const SizedBox(width: 12),
                      buildColumn(context, notifier, AppStrings.completedColumnTitle, AppStrings.completed, completed, Colors.green.shade100),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('${AppStrings.unexpectedError} $e')),
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
                    ? const Center(child: Text(AppStrings.noTaskYet, style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return LongPressDraggable<TaskEntity>(
                      data: task,
                      feedback: Opacity(
                        opacity: 0.9,
                        child: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TaskCard(task: task),
                          ),
                        ),
                      ),
                      child: TaskCard(
                        task: task,
                        onEdit: () => showEditTaskDialog(context, notifier, task),
                        onDelete: () async {
                          await notifier.deleteTask(task);
                          if (context.mounted) {
                            showToast(context, S.of(context)!.taskDelete, isSuccess: true);
                          }
                        },
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
