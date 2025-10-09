import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/task_model.dart';

class KanbanRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser?.uid ?? '';

  // Stream of tasks for current user
  Stream<List<TaskModel>> getTasks() {
    return _firestore
        .collection('kanban_tasks')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }

  Future<void> addTask(String title, String description,
      {String status = 'todo'}) async {
    await _firestore.collection('kanban_tasks').add({
      'title': title,
      'description': description,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': uid,
    });
  }

  Future<void> updateStatus(String taskId, String status) async {
    await _firestore.collection('kanban_tasks').doc(taskId).update({
      'status': status,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('kanban_tasks').doc(taskId).delete();
  }
}
