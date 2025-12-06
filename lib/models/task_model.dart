class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<TaskUpdate> updates;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    required this.updates,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TaskUpdate>? updates,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updates: updates ?? this.updates,
    );
  }
}

class TaskUpdate {
  final String id;
  final String description;
  final DateTime timestamp;
  final String author;

  TaskUpdate({
    required this.id,
    required this.description,
    required this.timestamp,
    required this.author,
  });
}

enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}