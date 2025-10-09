import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  // ✅ Factory to create TaskModel from Firestore document
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'todo',
    );
  }

  // Optional: toMap if you want to send to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
    };
  }
}
