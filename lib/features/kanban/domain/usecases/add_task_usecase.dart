import '../../data/task_repository/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<void> call(String title, String description, {String status = 'todo'}) {
    return repository.addTask(title, description, status: status);
  }
}
