import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/task_model.dart';
import '../models/notification_model.dart';
import '../models/performance_model.dart';

class DataService extends ChangeNotifier {
  UserModel? _currentUser;
  List<TaskModel> _tasks = [];
  List<NotificationModel> _notifications = [];
  PerformanceModel? _performance;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  List<TaskModel> get tasks => _tasks;
  List<NotificationModel> get notifications => _notifications;
  PerformanceModel? get performance => _performance;
  bool get isLoading => _isLoading;
  
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  DataService() {
    _initializeData();
  }

  void _initializeData() {
    _currentUser = UserModel(
      id: '1',
      name: 'Dr. Rajesh Kumar',
      email: 'dr.rajesh@example.com',
      phone: '+91 9876543210',
      profileImage: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400',
    );

    _tasks = [
      TaskModel(
        id: '1',
        title: 'YouTube Content Creation',
        description: 'Create 5 medical awareness shorts for this week',
        status: TaskStatus.inProgress,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updates: [
          TaskUpdate(
            id: '1',
            description: 'Script writing completed for 3 videos',
            timestamp: DateTime.now().subtract(Duration(hours: 5)),
            author: 'Content Team',
          ),
          TaskUpdate(
            id: '2',
            description: 'Video shooting in progress',
            timestamp: DateTime.now().subtract(Duration(hours: 2)),
            author: 'Production Team',
          ),
        ],
      ),
      TaskModel(
        id: '2',
        title: 'Social Media Audit',
        description: 'Monthly performance review and strategy planning',
        status: TaskStatus.pending,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updates: [],
      ),
      TaskModel(
        id: '3',
        title: 'Instagram Campaign',
        description: 'Launch awareness campaign for diabetes prevention',
        status: TaskStatus.completed,
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(hours: 12)),
        updates: [
          TaskUpdate(
            id: '3',
            description: 'Campaign design approved',
            timestamp: DateTime.now().subtract(Duration(days: 3)),
            author: 'Design Team',
          ),
          TaskUpdate(
            id: '4',
            description: 'Campaign launched successfully',
            timestamp: DateTime.now().subtract(Duration(hours: 12)),
            author: 'Marketing Team',
          ),
        ],
      ),
    ];

    _notifications = [
      NotificationModel(
        id: '1',
        title: 'New Task Update',
        description: 'YouTube Content Creation task has been updated',
        type: NotificationType.taskUpdate,
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
        relatedTaskId: '1',
      ),
      NotificationModel(
        id: '2',
        title: 'Performance Report Ready',
        description: 'Your monthly performance report is now available',
        type: NotificationType.performanceReport,
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
      ),
      NotificationModel(
        id: '3',
        title: 'Campaign Completed',
        description: 'Instagram Campaign has been completed successfully',
        type: NotificationType.taskUpdate,
        timestamp: DateTime.now().subtract(Duration(hours: 12)),
        isRead: true,
        relatedTaskId: '3',
      ),
    ];

    _performance = PerformanceModel(
      youtubeShorts: 24,
      totalViews: 15420,
      followers: 2840,
      leads: 156,
      viewsChart: [
        ChartData(label: 'Mon', value: 1200),
        ChartData(label: 'Tue', value: 1850),
        ChartData(label: 'Wed', value: 2100),
        ChartData(label: 'Thu', value: 1980),
        ChartData(label: 'Fri', value: 2400),
        ChartData(label: 'Sat', value: 2890),
        ChartData(label: 'Sun', value: 3200),
      ],
      followersChart: [
        ChartData(label: 'Week 1', value: 2650),
        ChartData(label: 'Week 2', value: 2720),
        ChartData(label: 'Week 3', value: 2790),
        ChartData(label: 'Week 4', value: 2840),
      ],
      leadsChart: [
        PieChartData(label: 'YouTube', value: 45, color: 0xFFFF5722),
        PieChartData(label: 'Instagram', value: 35, color: 0xFFE91E63),
        PieChartData(label: 'Facebook', value: 20, color: 0xFF2196F3),
      ],
    );
  }

  Future<void> addTaskUpdate(String taskId, String description) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 500));

    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final newUpdate = TaskUpdate(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: description,
        timestamp: DateTime.now(),
        author: 'You',
      );

      final updatedTask = _tasks[taskIndex].copyWith(
        updates: [..._tasks[taskIndex].updates, newUpdate],
        updatedAt: DateTime.now(),
      );

      _tasks[taskIndex] = updatedTask;

      final notification = NotificationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Task Updated',
        description: 'Task "${updatedTask.title}" has been updated',
        type: NotificationType.taskUpdate,
        timestamp: DateTime.now(),
        relatedTaskId: taskId,
      );

      _notifications.insert(0, notification);
    }

    _isLoading = false;
    notifyListeners();
  }

  void markNotificationAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 500));
    
    _currentUser = updatedUser;
    _isLoading = false;
    notifyListeners();
  }

  TaskModel? getTaskById(String taskId) {
    try {
      return _tasks.firstWhere((task) => task.id == taskId);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(Duration(seconds: 1));
    
    _isLoading = false;
    notifyListeners();
  }
}