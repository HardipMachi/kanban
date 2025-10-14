import '../entities/task_entity.dart';

abstract class TaskRepository {
  Stream<List<TaskEntity>> getTasks();
  Future<void> addTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> updateStatus(TaskEntity task, String status);
  Future<void> deleteTask(TaskEntity task);
}
