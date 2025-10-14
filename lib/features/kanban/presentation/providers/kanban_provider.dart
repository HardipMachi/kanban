import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/task_repository_impl/task_repository_impl.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/update_status_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../notifiers/kanban_notifiers.dart';

// Repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepositoryImpl());

// Use Cases
final addTaskUseCaseProvider = Provider<AddTaskUseCase>(
      (ref) => AddTaskUseCase(ref.read(taskRepositoryProvider)),
);

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>(
      (ref) => UpdateTaskUseCase(ref.read(taskRepositoryProvider)),
);

final updateStatusUseCaseProvider = Provider<UpdateStatusUseCase>(
      (ref) => UpdateStatusUseCase(ref.read(taskRepositoryProvider)),
);

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>(
      (ref) => DeleteTaskUseCase(ref.read(taskRepositoryProvider)),
);

final getTasksUseCaseProvider = Provider<GetTasksUseCase>(
      (ref) => GetTasksUseCase(ref.read(taskRepositoryProvider)),
);

// Notifier
final kanbanNotifierProvider = Provider<KanbanNotifier>(
      (ref) => KanbanNotifier(
    addTaskUseCase: ref.read(addTaskUseCaseProvider),
    updateTaskUseCase: ref.read(updateTaskUseCaseProvider),
    updateStatusUseCase: ref.read(updateStatusUseCaseProvider),
    deleteTaskUseCase: ref.read(deleteTaskUseCaseProvider),
  ),
);

// StreamProvider for tasks
final kanbanTasksProvider = StreamProvider<List<TaskEntity>>((ref) {
  final notifier = ref.read(kanbanNotifierProvider);
  final getTasksUseCase = ref.read(getTasksUseCaseProvider);
  return notifier.getTasks(getTasksUseCase); // ✅ returns Stream<List<TaskEntity>>
});
