import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Task task;
  final TextEditingController _updateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    task = widget.task;
  }

  @override
  void dispose() {
    _updateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Task Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primary),
            onPressed: _showEditTaskDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskHeader(),
            SizedBox(height: 24),
            _buildTaskDescription(),
            SizedBox(height: 24),
            _buildProgressSection(),
            SizedBox(height: 24),
            _buildUpdatesSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUpdateDialog,
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Update',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTaskHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(task.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(task.status),
                  style: TextStyle(
                    color: _getStatusColor(task.status),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 8),
              Text(
                'Created: ${DateFormat('MMM dd, yyyy').format(task.createdAt)}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              Spacer(),
              Icon(
                Icons.flag,
                size: 16,
                color: _getPriorityColor(task.priority),
              ),
              SizedBox(width: 4),
              Text(
                'Priority ${task.priority}',
                style: TextStyle(
                  color: _getPriorityColor(task.priority),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskDescription() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Text(
            task.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    double progress = _calculateProgress();
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStat('Total Updates', task.updates.length.toString()),
              _buildProgressStat('Last Update', _getLastUpdateTime()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdatesSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Updates Timeline',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          ...task.updates.asMap().entries.map((entry) {
            int index = entry.key;
            TaskUpdate update = entry.value;
            bool isLast = index == task.updates.length - 1;
            return _buildUpdateItem(update, isLast);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(TaskUpdate update, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: AppColors.divider,
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                update.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(update.timestamp),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '• ${update.updatedBy}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (!isLast) SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddUpdateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: Text('Add Update'),
          content: TextField(
            controller: _updateController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter update description...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateController.clear();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_updateController.text.trim().isNotEmpty) {
                  _addUpdate(_updateController.text.trim());
                  Navigator.of(context).pop();
                  _updateController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid update'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: Text('Add Update'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog() {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateTask(
                  titleController.text.trim(),
                  descriptionController.text.trim(),
                );
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addUpdate(String description) {
    setState(() {
      final newUpdate = TaskUpdate(
        id: '${task.id}-${task.updates.length + 1}',
        description: description,
        timestamp: DateTime.now(),
        updatedBy: 'Dr. Rajesh Kumar',
      );
      
      task.updates.add(newUpdate);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Update added successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _updateTask(String title, String description) {
    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    setState(() {
      task = Task(
        id: task.id,
        title: title,
        description: description,
        status: task.status,
        createdAt: task.createdAt,
        updatedAt: DateTime.now(),
        updates: task.updates,
        priority: task.priority,
      );
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task updated successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  double _calculateProgress() {
    switch (task.status) {
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

  String _getLastUpdateTime() {
    if (task.updates.isEmpty) return 'No updates';
    
    final lastUpdate = task.updates.last.timestamp;
    final now = DateTime.now();
    final difference = now.difference(lastUpdate);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
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
}