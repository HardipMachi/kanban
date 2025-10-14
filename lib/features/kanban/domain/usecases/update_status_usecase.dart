import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateStatusUseCase {
  final TaskRepository repository;

  UpdateStatusUseCase(this.repository);

  Future<void> call(TaskEntity task, String status) {
    return repository.updateStatus(task, status);
  }
}
