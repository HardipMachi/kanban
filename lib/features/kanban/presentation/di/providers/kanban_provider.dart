import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanban/core/di/data_module.dart';
import 'package:kanban/features/kanban/data/task_repository_impl/task_repository_impl.dart';
import 'package:kanban/features/kanban/domain/entities/task_entity.dart';
import 'package:kanban/features/kanban/domain/repositories/task_repository.dart';
import 'package:kanban/features/kanban/domain/usecases/add_task_usecase.dart';
import 'package:kanban/features/kanban/domain/usecases/delete_task_usecase.dart';
import 'package:kanban/features/kanban/domain/usecases/get_tasks_usecase.dart';
import 'package:kanban/features/kanban/domain/usecases/update_status_usecase.dart';
import 'package:kanban/features/kanban/domain/usecases/update_task_usecase.dart';
import 'package:kanban/features/kanban/presentation/di/notifiers/kanban_notifiers.dart';

// Repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
final firestore = ref.read(firebaseFirestoreProvider);
final auth = ref.read(firebaseAuthProvider);
return TaskRepositoryImpl(firestore: firestore, auth: auth);
});

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
  return notifier.getTasks(getTasksUseCase);
});
