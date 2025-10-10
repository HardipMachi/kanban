import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/task_model.dart';

class TaskRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<TaskModel>> getTasks() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }

  Future<void> addTask(String title, String description, {String status = 'todo'}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('tasks').add({
      'title': title,
      'description': description,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': uid,
    });
  }

  Future<void> updateTask(String taskId, String title, String description) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'title': title,
      'description': description,
    });
  }

  Future<void> updateStatus(String taskId, String status) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': status,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}
