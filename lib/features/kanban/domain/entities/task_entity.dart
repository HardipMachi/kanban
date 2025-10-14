class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String status;
  final String userId;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.userId,
  });

  TaskEntity copyWith({
    String? title,
    String? description,
    String? status,
  }) {
    return TaskEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      userId: userId,
    );
  }
}
