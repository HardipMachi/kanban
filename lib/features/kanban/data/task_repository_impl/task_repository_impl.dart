import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../model/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  TaskRepositoryImpl({
    required this.firestore,
    required this.auth,
  });

  // ------------------ GET TASKS ------------------
  @override
  Stream<List<TaskEntity>> getTasks() {
    final uid = auth.currentUser?.uid ?? '';
    return firestore
        .collection('tasks')
        .where('userId', isEqualTo: uid) // current user
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final model = TaskModel.fromFirestore(doc);
      return TaskEntity(
        id: model.id,
        title: model.title,
        description: model.description,
        status: model.status,
        userId: uid,
      );
    }).toList());
  }

  // ------------------ ADD TASK ------------------
  @override
  Future<void> addTask(TaskEntity task) async {
    final uid = auth.currentUser?.uid ?? '';
    await firestore.collection('tasks').add({
      'title': task.title,
      'description': task.description,
      'status': task.status,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': uid,
    });
  }

  // ------------------ UPDATE TASK ------------------
  @override
  Future<void> updateTask(TaskEntity task) async {
    await firestore.collection('tasks').doc(task.id).update({
      'title': task.title,
      'description': task.description,
    });
  }

  // ------------------ UPDATE STATUS ------------------
  @override
  Future<void> updateStatus(TaskEntity task, String status) async {
    await firestore.collection('tasks').doc(task.id).update({
      'status': status,
    });
  }

  // ------------------ DELETE TASK ------------------
  @override
  Future<void> deleteTask(TaskEntity task) async {
    await firestore.collection('tasks').doc(task.id).delete();
  }
}
