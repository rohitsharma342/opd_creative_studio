import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../services/data_service.dart';
import '../widgets/performance_card.dart';
import '../widgets/chart_widget.dart';
import '../widgets/task_item.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/constants.dart';
import 'task_details_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardContent(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Consumer<DataService>(
              builder: (context, dataService, child) {
                final unreadCount = dataService.unreadNotificationsCount;
                return Stack(
                  children: [
                    Icon(Icons.notifications_outlined),
                    if (unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppConstants.error,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            unreadCount.toString(),
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
                );
              },
            ),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatefulWidget {
  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<DataService>().refreshData(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.primaryColor.withOpacity(0.1),
                        Colors.white,
                      ],
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(16, 60, 16, 16),
                  child: Consumer<DataService>(
                    builder: (context, dataService, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                  dataService.currentUser?.profileImage ??
                                      AppConstants.sampleImages[0],
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back!',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      dataService.currentUser?.name ?? 'Doctor',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppConstants.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _searchQuery = value),
                      decoration: InputDecoration(
                        hintText: 'Search tasks or reports...',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Performance Overview',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Consumer<DataService>(
              builder: (context, dataService, child) {
                final performance = dataService.performance;
                if (performance == null) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return SliverToBoxAdapter(
                  child: AnimationLimiter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: Duration(milliseconds: 600),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: PerformanceCard(
                                    title: 'YouTube Shorts',
                                    value: performance.youtubeShorts.toString(),
                                    icon: Icons.video_library,
                                    color: Colors.red,
                                    onTap: () => _showChartDialog(
                                      context,
                                      'YouTube Views Trend',
                                      ChartWidget(
                                        title: 'Views This Week',
                                        data: performance.viewsChart,
                                        type: ChartType.line,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: PerformanceCard(
                                    title: 'Total Views',
                                    value: _formatNumber(performance.totalViews),
                                    icon: Icons.visibility,
                                    color: Colors.blue,
                                    onTap: () => _showChartDialog(
                                      context,
                                      'Views Analytics',
                                      ChartWidget(
                                        title: 'Daily Views',
                                        data: performance.viewsChart,
                                        type: ChartType.line,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: PerformanceCard(
                                    title: 'Followers',
                                    value: _formatNumber(performance.followers),
                                    icon: Icons.people,
                                    color: Colors.green,
                                    onTap: () => _showChartDialog(
                                      context,
                                      'Follower Growth',
                                      ChartWidget(
                                        title: 'Weekly Growth',
                                        data: performance.followersChart,
                                        type: ChartType.bar,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: PerformanceCard(
                                    title: 'Leads',
                                    value: performance.leads.toString(),
                                    icon: Icons.trending_up,
                                    color: Colors.orange,
                                    onTap: () => _showChartDialog(
                                      context,
                                      'Lead Sources',
                                      ChartWidget(
                                        title: 'Lead Distribution',
                                        pieData: performance.leadsChart,
                                        type: ChartType.pie,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Recent Tasks',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Consumer<DataService>(
              builder: (context, dataService, child) {
                final tasks = dataService.tasks
                    .where((task) => task.title
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();

                if (tasks.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.task_outlined,
                            size: 64,
                            color: AppConstants.textSecondary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'No tasks available'
                                : 'No tasks found for "$_searchQuery"',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 600),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: TaskItem(
                                task: tasks[index],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailsScreen(
                                      taskId: tasks[index].id,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: tasks.length,
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Text(
                  AppConstants.copyrightText,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
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

  void _showChartDialog(BuildContext context, String title, Widget chart) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: chart,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}