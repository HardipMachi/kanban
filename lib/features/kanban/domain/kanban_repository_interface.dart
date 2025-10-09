import '../data/model/task_model.dart';

abstract class KanbanRepositoryInterface {
  Future<void> addTask(TaskModel task);
  Future<void> updateTaskStatus(String id, String status);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
  Stream<List<TaskModel>> getTasks();
}
