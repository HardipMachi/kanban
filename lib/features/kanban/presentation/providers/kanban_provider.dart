// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../../data/kanban_repository.dart';
// // import '../../data/model/task_model.dart';
// //
// // // Repository provider
// // final kanbanRepositoryProvider = Provider<KanbanRepository>((ref) => KanbanRepository());
// //
// // // Stream of tasks
// // final kanbanTasksProvider = StreamProvider<List<TaskModel>>((ref) {
// //   final repo = ref.read(kanbanRepositoryProvider);
// //   return repo.getTasks();
// // });
// //
// // // Notifier provider
// // final kanbanNotifierProvider = Provider<KanbanNotifier>((ref) {
// //   final repo = ref.read(kanbanRepositoryProvider);
// //   return KanbanNotifier(repo);
// // });
// //
// // class KanbanNotifier {
// //   final KanbanRepository repo;
// //   KanbanNotifier(this.repo);
// //
// //   Future<void> addTask(String title, String description,
// //       {String status = 'todo'}) async {
// //     await repo.addTask(title, description, status: status);
// //   }
// //
// //   Future<void> updateStatus(String taskId, String status) async {
// //     await repo.updateStatus(taskId, status);
// //   }
// //
// //   Future<void> deleteTask(String taskId) async {
// //     await repo.deleteTask(taskId);
// //   }
// // }
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/model/task_model.dart';
// import '../../data/task_repository/task_repository.dart';
//
// // Repository Provider
// final taskRepositoryProvider = Provider((ref) => TaskRepository());
//
// // Stream Provider for tasks
// final kanbanTasksProvider = StreamProvider<List<TaskModel>>((ref) {
//   final repository = ref.watch(taskRepositoryProvider);
//   return repository.getTasks();
// });
//
// // Notifier for actions
// final kanbanNotifierProvider = Provider((ref) {
//   final repo = ref.watch(taskRepositoryProvider);
//   return KanbanNotifier(repo);
// });
//
// class KanbanNotifier {
//   final TaskRepository repository;
//
//   KanbanNotifier(this.repository);
//
//   Future<void> addTask(String title, String description) => repository.addTask(title, description);
//
//   Future<void> updateTask(String taskId, String title, String description) =>
//       repository.updateTask(taskId, title, description);
//
//   Future<void> updateStatus(String taskId, String status) =>
//       repository.updateStatus(taskId, status);
//
//   Future<void> deleteTask(String taskId) => repository.deleteTask(taskId);
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/task_repository/task_repository.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/update_status_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../data/model/task_model.dart';
import '../notifiers/kanban_notifiers.dart';

// Repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository());

// Use Cases
final addTaskUseCaseProvider = Provider<AddTaskUseCase>((ref) => AddTaskUseCase(ref.read(taskRepositoryProvider)));
final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) => UpdateTaskUseCase(ref.read(taskRepositoryProvider)));
final updateStatusUseCaseProvider = Provider<UpdateStatusUseCase>((ref) => UpdateStatusUseCase(ref.read(taskRepositoryProvider)));
final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) => DeleteTaskUseCase(ref.read(taskRepositoryProvider)));
final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) => GetTasksUseCase(ref.read(taskRepositoryProvider)));

// Notifier
final kanbanNotifierProvider = Provider<KanbanNotifier>((ref) => KanbanNotifier(
  addTaskUseCase: ref.read(addTaskUseCaseProvider),
  updateTaskUseCase: ref.read(updateTaskUseCaseProvider),
  updateStatusUseCase: ref.read(updateStatusUseCaseProvider),
  deleteTaskUseCase: ref.read(deleteTaskUseCaseProvider),
));

// StreamProvider for tasks
final kanbanTasksProvider = StreamProvider<List<TaskModel>>((ref) {
  final notifier = ref.read(kanbanNotifierProvider);
  final getTasksUseCase = ref.read(getTasksUseCaseProvider);
  return notifier.getTasks(getTasksUseCase);
});
