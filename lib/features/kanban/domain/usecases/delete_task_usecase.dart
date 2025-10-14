import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(TaskEntity task) {
    return repository.deleteTask(task);
  }
}
