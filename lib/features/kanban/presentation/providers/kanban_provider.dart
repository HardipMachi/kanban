import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/kanban_repository.dart';
import '../../data/model/task_model.dart';

// Repository provider
final kanbanRepositoryProvider = Provider<KanbanRepository>((ref) => KanbanRepository());

// Stream of tasks
final kanbanTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final repo = ref.read(kanbanRepositoryProvider);
  return repo.getTasks();
});

// Notifier provider
final kanbanNotifierProvider = Provider<KanbanNotifier>((ref) {
  final repo = ref.read(kanbanRepositoryProvider);
  return KanbanNotifier(repo);
});

class KanbanNotifier {
  final KanbanRepository repo;
  KanbanNotifier(this.repo);

  Future<void> addTask(String title, String description,
      {String status = 'todo'}) async {
    await repo.addTask(title, description, status: status);
  }

  Future<void> updateStatus(String taskId, String status) async {
    await repo.updateStatus(taskId, status);
  }

  Future<void> deleteTask(String taskId) async {
    await repo.deleteTask(taskId);
  }
}
