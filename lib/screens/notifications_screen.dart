import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../services/data_service.dart';
import '../models/notification_model.dart';
import '../utils/constants.dart';
import 'task_details_screen.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<DataService>(
            builder: (context, dataService, child) {
              final hasUnread = dataService.unreadNotificationsCount > 0;
              return TextButton(
                onPressed: hasUnread
                    ? () {
                        dataService.markAllNotificationsAsRead();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('All notifications marked as read'),
                            backgroundColor: AppConstants.success,
                          ),
                        );
                      }
                    : null,
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: hasUnread ? AppConstants.primaryColor : AppConstants.textSecondary,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          final notifications = dataService.notifications;

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 80,
                    color: AppConstants.textSecondary,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'No notifications',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'You\'re all caught up! Check back later for updates.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => dataService.refreshData(),
            child: AnimationLimiter(
              child: ListView.builder(
                padding: AppConstants.defaultPadding,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          child: NotificationCard(
                            notification: notification,
                            onTap: () => _handleNotificationTap(
                              context,
                              notification,
                              dataService,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
    DataService dataService,
  ) {
    if (!notification.isRead) {
      dataService.markNotificationAsRead(notification.id);
    }

    switch (notification.type) {
      case NotificationType.taskUpdate:
        if (notification.relatedTaskId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailsScreen(
                taskId: notification.relatedTaskId!,
              ),
            ),
          );
        }
        break;
      case NotificationType.performanceReport:
        DefaultTabController.of(context)?.animateTo(0);
        break;
      case NotificationType.systemAlert:
      case NotificationType.reminder:
        break;
    }
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: notification.isRead ? 1 : 3,
      color: notification.isRead ? null : AppConstants.primaryColor.withOpacity(0.02),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppConstants.defaultRadius,
        child: Padding(
          padding: AppConstants.defaultPadding,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTypeIcon(),
                  color: _getTypeColor(),
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      notification.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppConstants.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (notification.type) {
      case NotificationType.taskUpdate:
        return AppConstants.primaryColor;
      case NotificationType.performanceReport:
        return Colors.blue;
      case NotificationType.systemAlert:
        return AppConstants.warning;
      case NotificationType.reminder:
        return AppConstants.success;
    }
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.taskUpdate:
        return Icons.task_outlined;
      case NotificationType.performanceReport:
        return Icons.analytics_outlined;
      case NotificationType.systemAlert:
        return Icons.warning_outlined;
      case NotificationType.reminder:
        return Icons.schedule_outlined;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}