import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/update_status_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../data/model/task_model.dart';

class KanbanNotifier extends StateNotifier<void> {
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final UpdateStatusUseCase updateStatusUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;

  KanbanNotifier({
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.updateStatusUseCase,
    required this.deleteTaskUseCase,
  }) : super(null);

  Future<void> addTask(String title, String description) async {
    await addTaskUseCase(title, description);
  }

  Future<void> updateTask(TaskModel task, String newTitle, String newDesc) async {
    await updateTaskUseCase(task.id, newTitle, newDesc);
  }

  Future<void> updateStatus(TaskModel task, String status) async {
    await updateStatusUseCase(task.id, status);
  }

  Future<void> deleteTask(TaskModel task) async {
    await deleteTaskUseCase(task.id);
  }

  Stream<List<TaskModel>> getTasks(GetTasksUseCase getTasksUseCase) {
    return getTasksUseCase();
  }
}
