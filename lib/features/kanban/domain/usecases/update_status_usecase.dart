import '../../data/task_repository/task_repository.dart';

class UpdateStatusUseCase {
  final TaskRepository repository;

  UpdateStatusUseCase(this.repository);

  Future<void> call(String taskId, String status) {
    return repository.updateStatus(taskId, status);
  }
}
