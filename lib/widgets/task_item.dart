import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskItem({
    Key? key,
    required this.task,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: _getStatusColor(task.status).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(task.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(task.status),
                        style: TextStyle(
                          color: _getStatusColor(task.status),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.update,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Updated ${_getRelativeTime(task.updatedAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.flag,
                      size: 14,
                      color: _getPriorityColor(task.priority),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'P${task.priority}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getPriorityColor(task.priority),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${task.updates.length} updates',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _getProgressValue(task.status),
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getStatusColor(task.status),
                  ),
                  minHeight: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.inProgress:
        return AppColors.info;
      case TaskStatus.onHold:
        return AppColors.warning;
      case TaskStatus.pending:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.onHold:
        return 'On Hold';
      case TaskStatus.pending:
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  double _getProgressValue(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return 1.0;
      case TaskStatus.inProgress:
        return 0.6;
      case TaskStatus.onHold:
        return 0.3;
      case TaskStatus.pending:
        return 0.1;
      default:
        return 0.0;
    }
  }

  String _getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }
}