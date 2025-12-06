import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/notification.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class NotificationsScreen extends StatefulWidget {
  final List<AppNotification> notifications;
  final Function(AppNotification) onNotificationRead;

  const NotificationsScreen({
    Key? key,
    required this.notifications,
    required this.onNotificationRead,
  }) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AppNotification> notifications;

  @override
  void initState() {
    super.initState();
    notifications = List.from(widget.notifications);
  }

  @override
  Widget build(BuildContext context) {
    final unreadNotifications = notifications.where((n) => !n.isRead).length;
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (unreadNotifications > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all as read',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                if (unreadNotifications > 0)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    color: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      '$unreadNotifications unread notification${unreadNotifications > 1 ? 's' : ''}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return _buildNotificationItem(notification);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            'No Notifications',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You\'re all caught up!\nWe\'ll notify you when something new happens.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(AppNotification notification) {
    return GestureDetector(
      onTap: () => _onNotificationTap(notification),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(
            color: notification.isRead ? AppColors.divider : AppColors.primary.withOpacity(0.2),
            width: notification.isRead ? 1 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getNotificationTypeColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getNotificationTypeIcon(notification.type),
                    size: 20,
                    color: _getNotificationTypeColor(notification.type),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              notification.description,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            if (notification.relatedId != null) ..[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tap to view details',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onNotificationTap(AppNotification notification) {
    if (!notification.isRead) {
      setState(() {
        int index = notifications.indexOf(notification);
        notifications[index] = notification.copyWith(isRead: true);
      });
      widget.onNotificationRead(notification);
    }

    if (notification.relatedId != null) {
      _navigateToRelatedScreen(notification);
    }
  }

  void _navigateToRelatedScreen(AppNotification notification) {
    switch (notification.type) {
      case NotificationType.taskUpdate:
        Navigator.of(context).pop();
        break;
      case NotificationType.performanceUpdate:
        Navigator.of(context).pop();
        break;
      case NotificationType.newLead:
        Navigator.of(context).pop();
        break;
      default:
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to ${_getNotificationTypeText(notification.type)} screen'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      notifications = notifications.map((notification) {
        if (!notification.isRead) {
          widget.onNotificationRead(notification);
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  IconData _getNotificationTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.performanceUpdate:
        return Icons.trending_up;
      case NotificationType.taskUpdate:
        return Icons.task_alt;
      case NotificationType.newLead:
        return Icons.person_add;
      case NotificationType.milestone:
        return Icons.emoji_events;
      case NotificationType.general:
      default:
        return Icons.info;
    }
  }

  Color _getNotificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.performanceUpdate:
        return AppColors.info;
      case NotificationType.taskUpdate:
        return AppColors.primary;
      case NotificationType.newLead:
        return AppColors.success;
      case NotificationType.milestone:
        return Colors.amber;
      case NotificationType.general:
      default:
        return AppColors.textSecondary;
    }
  }

  String _getNotificationTypeText(NotificationType type) {
    switch (type) {
      case NotificationType.performanceUpdate:
        return 'performance';
      case NotificationType.taskUpdate:
        return 'task details';
      case NotificationType.newLead:
        return 'leads';
      case NotificationType.milestone:
        return 'milestone';
      case NotificationType.general:
      default:
        return 'general';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(timestamp);
    }
  }
}