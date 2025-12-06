class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TaskUpdate> updates;
  final int priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.updates,
    this.priority = 1,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.values[json['status']],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      updates: (json['updates'] as List)
          .map((update) => TaskUpdate.fromJson(update))
          .toList(),
      priority: json['priority'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'updates': updates.map((update) => update.toJson()).toList(),
      'priority': priority,
    };
  }
}

enum TaskStatus {
  pending,
  inProgress,
  completed,
  onHold,
}

class TaskUpdate {
  final String id;
  final String description;
  final DateTime timestamp;
  final String updatedBy;

  TaskUpdate({
    required this.id,
    required this.description,
    required this.timestamp,
    required this.updatedBy,
  });

  factory TaskUpdate.fromJson(Map<String, dynamic> json) {
    return TaskUpdate(
      id: json['id'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'updatedBy': updatedBy,
    };
  }
}