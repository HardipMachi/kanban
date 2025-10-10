import '../../data/model/task_model.dart';
import '../../data/task_repository/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Stream<List<TaskModel>> call() {
    return repository.getTasks();
  }
}
