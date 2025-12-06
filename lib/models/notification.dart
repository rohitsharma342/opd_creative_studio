class AppNotification {
  final String id;
  final String title;
  final String description;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? relatedId;
  final String? actionUrl;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.relatedId,
    this.actionUrl,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: NotificationType.values[json['type']],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      relatedId: json['relatedId'],
      actionUrl: json['actionUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'relatedId': relatedId,
      'actionUrl': actionUrl,
    };
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? description,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? relatedId,
    String? actionUrl,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}

enum NotificationType {
  performanceUpdate,
  taskUpdate,
  newLead,
  milestone,
  general,
}