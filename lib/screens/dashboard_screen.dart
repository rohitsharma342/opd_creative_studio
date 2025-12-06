import 'package:flutter/material.dart';
import '../models/performance_metrics.dart';
import '../models/task.dart';
import '../models/notification.dart';
import '../services/static_data_service.dart';
import '../widgets/performance_card.dart';
import '../widgets/chart_widget.dart';
import '../widgets/task_item.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'task_details_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late PerformanceMetrics performanceMetrics;
  late List<Task> tasks;
  late List<AppNotification> notifications;
  int _selectedIndex = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      performanceMetrics = StaticDataService.getPerformanceMetrics();
      tasks = StaticDataService.getTasks();
      notifications = StaticDataService.getNotifications();
    });
  }

  int get unreadNotificationCount =>
      notifications.where((n) => !n.isRead).length;

  List<Task> get filteredTasks {
    if (searchQuery.isEmpty) return tasks;
    return tasks
        .where((task) =>
            task.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            task.description.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: _selectedIndex == 0 ? _buildDashboard() : ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          _loadData();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeader(),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildSearchBar(),
                  _buildPerformanceCards(),
                  _buildChartsSection(),
                  _buildTasksSection(),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=150&h=150&fit=crop&crop=face',
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Dr. Rajesh Kumar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsScreen(
                        notifications: notifications,
                        onNotificationRead: (notification) {
                          setState(() {
                            int index = notifications.indexOf(notification);
                            notifications[index] = notification.copyWith(isRead: true);
                          });
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textSecondary,
                ),
              ),
              if (unreadNotificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadNotificationCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: Icon(Icons.search, color: AppColors.textLight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPerformanceCards() {
    return Container(
      height: 140,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          PerformanceCard(
            title: 'YouTube Shorts',
            value: performanceMetrics.youtube.shortsPosted.toString(),
            subtitle: 'Posted this month',
            icon: Icons.video_library,
            color: Colors.red,
            onTap: () => _showChartDialog('YouTube Views', performanceMetrics.youtube.viewsChart),
          ),
          PerformanceCard(
            title: 'Total Followers',
            value: _formatNumber(performanceMetrics.socialMedia.totalFollowers),
            subtitle: 'Across all platforms',
            icon: Icons.group,
            color: Colors.blue,
            onTap: () => _showChartDialog('Followers by Platform', performanceMetrics.socialMedia.followersChart),
          ),
          PerformanceCard(
            title: 'Leads Generated',
            value: performanceMetrics.leads.totalLeads.toString(),
            subtitle: '${performanceMetrics.leads.conversionRate.toStringAsFixed(1)}% conversion',
            icon: Icons.trending_up,
            color: Colors.green,
            onTap: () => _showChartDialog('Leads Over Time', performanceMetrics.leads.leadsChart),
          ),
          PerformanceCard(
            title: 'Total Views',
            value: _formatNumber(performanceMetrics.youtube.totalViews),
            subtitle: 'YouTube video views',
            icon: Icons.visibility,
            color: Colors.purple,
            onTap: () => _showChartDialog('Views Over Time', performanceMetrics.youtube.viewsChart),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Overview',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          ChartWidget(
            title: 'YouTube Views Trend',
            data: performanceMetrics.youtube.viewsChart,
            chartType: ChartType.line,
          ),
          SizedBox(height: 16),
          ChartWidget(
            title: 'Leads by Source',
            pieData: performanceMetrics.leads.leadsSourceChart,
            chartType: ChartType.pie,
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Tasks',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ...filteredTasks.take(5).map((task) => TaskItem(
            task: task,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailsScreen(task: task),
                ),
              );
            },
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Last updated: ${_formatDateTime(performanceMetrics.lastUpdated)}',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            AppConstants.copyrightText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textLight,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showChartDialog(String title, List<ChartData> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  child: ChartWidget(
                    title: '',
                    data: data,
                    chartType: ChartType.bar,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}