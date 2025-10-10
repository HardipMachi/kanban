import '../../data/task_repository/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(String taskId, String title, String description) {
    return repository.updateTask(taskId, title, description);
  }
}
