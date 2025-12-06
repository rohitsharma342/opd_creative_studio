import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../services/data_service.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final TextEditingController _updateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) {
                  _titleController.clear();
                  _descriptionController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Consumer<DataService>(
        builder: (context, dataService, child) {
          final task = dataService.getTaskById(widget.taskId);
          
          if (task == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppConstants.textSecondary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Task not found',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The requested task could not be loaded',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (_isEditing && _titleController.text.isEmpty) {
            _titleController.text = task.title;
            _descriptionController.text = task.description;
          }

          return SingleChildScrollView(
            padding: AppConstants.defaultPadding,
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: Duration(milliseconds: 600),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Card(
                      child: Padding(
                        padding: AppConstants.defaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isEditing) ...
                              [
                                TextField(
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    labelText: 'Task Title',
                                    border: OutlineInputBorder(),
                                  ),
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 16),
                                TextField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    labelText: 'Description',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = false;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Task updated successfully'),
                                            backgroundColor: AppConstants.success,
                                          ),
                                        );
                                      },
                                      child: Text('Save Changes'),
                                    ),
                                    SizedBox(width: 12),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = false;
                                        });
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  ],
                                ),
                              ]
                            else ...
                              [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        task.title,
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                          fontSize: 20,
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
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  task.description,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: AppConstants.textSecondary,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Created: ${_formatDate(task.createdAt)}',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                if (task.updatedAt != null) ...
                                  [
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.update,
                                          size: 16,
                                          color: AppConstants.textSecondary,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Updated: ${_formatDate(task.updatedAt!)}',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                              ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress Updates',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showAddUpdateDialog(context, dataService),
                          icon: Icon(Icons.add),
                          label: Text('Add Update'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (task.updates.isEmpty)
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.timeline,
                                size: 48,
                                color: AppConstants.textSecondary,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No updates yet',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add the first update to track progress',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...task.updates.asMap().entries.map((entry) {
                        final index = entry.key;
                        final update = entry.value;
                        final isLast = index == task.updates.length - 1;
                        
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: Duration(milliseconds: 400),
                          child: SlideAnimation(
                            horizontalOffset: 30.0,
                            child: FadeInAnimation(
                              child: Container(
                                margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: AppConstants.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        if (!isLast)
                                          Container(
                                            width: 2,
                                            height: 60,
                                            color: AppConstants.primaryColor.withOpacity(0.3),
                                          ),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Card(
                                        margin: EdgeInsets.zero,
                                        child: Padding(
                                          padding: AppConstants.defaultPadding,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                update.description,
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'By ${update.author}',
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatDateTime(update.timestamp),
                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddUpdateDialog(BuildContext context, DataService dataService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Progress Update'),
        content: TextField(
          controller: _updateController,
          decoration: InputDecoration(
            hintText: 'Describe the progress made...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _updateController.clear();
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_updateController.text.trim().isNotEmpty) {
                await dataService.addTaskUpdate(
                  widget.taskId,
                  _updateController.text.trim(),
                );
                _updateController.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Update added successfully'),
                    backgroundColor: AppConstants.success,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter an update description'),
                    backgroundColor: AppConstants.error,
                  ),
                );
              }
            },
            child: Text('Add Update'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return AppConstants.warning;
      case TaskStatus.inProgress:
        return AppConstants.primaryColor;
      case TaskStatus.completed:
        return AppConstants.success;
      case TaskStatus.cancelled:
        return AppConstants.error;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _updateController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}