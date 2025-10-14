import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/update_status_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';

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

  // ------------------ ADD TASK ------------------
  Future<void> addTask(TaskEntity task) async {
    await addTaskUseCase(task);
  }

  // ------------------ UPDATE TASK ------------------
  Future<void> updateTask(TaskEntity task, String newTitle, String newDesc) async {
    final updatedTask = task.copyWith(title: newTitle, description: newDesc);
    await updateTaskUseCase(updatedTask);
  }

  // ------------------ UPDATE STATUS ------------------
  Future<void> updateStatus(TaskEntity task, String status) async {
    await updateStatusUseCase(task, status);
  }

  // ------------------ DELETE TASK ------------------
  Future<void> deleteTask(TaskEntity task) async {
    await deleteTaskUseCase(task);
  }

  // ------------------ GET TASKS ------------------
  Stream<List<TaskEntity>> getTasks(GetTasksUseCase useCase) {
    return useCase();
  }
}
