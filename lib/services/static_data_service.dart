import '../models/task.dart';
import '../models/performance_metrics.dart';
import '../models/notification.dart';

class StaticDataService {
  static PerformanceMetrics getPerformanceMetrics() {
    return PerformanceMetrics(
      youtube: YouTubeMetrics(
        shortsPosted: 45,
        totalViews: 125000,
        subscribers: 2340,
        avgViewDuration: 32.5,
        viewsChart: [
          ChartData(label: 'Jan', value: 15000, date: DateTime(2024, 1)),
          ChartData(label: 'Feb', value: 18000, date: DateTime(2024, 2)),
          ChartData(label: 'Mar', value: 22000, date: DateTime(2024, 3)),
          ChartData(label: 'Apr', value: 19000, date: DateTime(2024, 4)),
          ChartData(label: 'May', value: 25000, date: DateTime(2024, 5)),
          ChartData(label: 'Jun', value: 26000, date: DateTime(2024, 6)),
        ],
        subscribersChart: [
          ChartData(label: 'Jan', value: 1800, date: DateTime(2024, 1)),
          ChartData(label: 'Feb', value: 1950, date: DateTime(2024, 2)),
          ChartData(label: 'Mar', value: 2100, date: DateTime(2024, 3)),
          ChartData(label: 'Apr', value: 2180, date: DateTime(2024, 4)),
          ChartData(label: 'May', value: 2250, date: DateTime(2024, 5)),
          ChartData(label: 'Jun', value: 2340, date: DateTime(2024, 6)),
        ],
      ),
      socialMedia: SocialMediaMetrics(
        instagramFollowers: 3450,
        facebookFollowers: 1890,
        linkedinFollowers: 780,
        totalEngagement: 12500,
        followersChart: [
          ChartData(label: 'Instagram', value: 3450),
          ChartData(label: 'Facebook', value: 1890),
          ChartData(label: 'LinkedIn', value: 780),
        ],
        engagementChart: [
          ChartData(label: 'Likes', value: 7500),
          ChartData(label: 'Comments', value: 2800),
          ChartData(label: 'Shares', value: 2200),
        ],
      ),
      leads: LeadsMetrics(
        totalLeads: 89,
        qualifiedLeads: 56,
        convertedLeads: 23,
        conversionRate: 25.8,
        leadsChart: [
          ChartData(label: 'Jan', value: 12, date: DateTime(2024, 1)),
          ChartData(label: 'Feb', value: 15, date: DateTime(2024, 2)),
          ChartData(label: 'Mar', value: 18, date: DateTime(2024, 3)),
          ChartData(label: 'Apr', value: 14, date: DateTime(2024, 4)),
          ChartData(label: 'May', value: 16, date: DateTime(2024, 5)),
          ChartData(label: 'Jun', value: 14, date: DateTime(2024, 6)),
        ],
        leadsSourceChart: [
          PieChartData(label: 'Social Media', value: 45, color: '#EE5109'),
          PieChartData(label: 'Google Ads', value: 30, color: '#2196F3'),
          PieChartData(label: 'Referrals', value: 15, color: '#4CAF50'),
          PieChartData(label: 'Direct', value: 10, color: '#FF9800'),
        ],
      ),
      lastUpdated: DateTime.now().subtract(Duration(hours: 2)),
    );
  }

  static List<Task> getTasks() {
    return [
      Task(
        id: '1',
        title: 'Create YouTube Shorts for Cardiology',
        description: 'Develop 5 educational shorts about heart health',
        status: TaskStatus.inProgress,
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        updatedAt: DateTime.now().subtract(Duration(hours: 6)),
        priority: 1,
        updates: [
          TaskUpdate(
            id: '1-1',
            description: 'Task created and assigned to content team',
            timestamp: DateTime.now().subtract(Duration(days: 3)),
            updatedBy: 'Admin',
          ),
          TaskUpdate(
            id: '1-2',
            description: 'Script writing completed for 3 shorts',
            timestamp: DateTime.now().subtract(Duration(days: 2)),
            updatedBy: 'Content Writer',
          ),
          TaskUpdate(
            id: '1-3',
            description: 'Video production started',
            timestamp: DateTime.now().subtract(Duration(hours: 6)),
            updatedBy: 'Video Editor',
          ),
        ],
      ),
      Task(
        id: '2',
        title: 'Instagram Campaign Setup',
        description: 'Configure targeted ads for dermatology services',
        status: TaskStatus.completed,
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        priority: 2,
        updates: [
          TaskUpdate(
            id: '2-1',
            description: 'Campaign strategy finalized',
            timestamp: DateTime.now().subtract(Duration(days: 5)),
            updatedBy: 'Marketing Manager',
          ),
          TaskUpdate(
            id: '2-2',
            description: 'Ad creatives approved by client',
            timestamp: DateTime.now().subtract(Duration(days: 3)),
            updatedBy: 'Designer',
          ),
          TaskUpdate(
            id: '2-3',
            description: 'Campaign launched successfully',
            timestamp: DateTime.now().subtract(Duration(days: 1)),
            updatedBy: 'Marketing Manager',
          ),
        ],
      ),
      Task(
        id: '3',
        title: 'Website Content Update',
        description: 'Update service pages with new information',
        status: TaskStatus.pending,
        createdAt: DateTime.now().subtract(Duration(days: 1)),
        updatedAt: DateTime.now().subtract(Duration(days: 1)),
        priority: 3,
        updates: [
          TaskUpdate(
            id: '3-1',
            description: 'Task created and awaiting content review',
            timestamp: DateTime.now().subtract(Duration(days: 1)),
            updatedBy: 'Admin',
          ),
        ],
      ),
      Task(
        id: '4',
        title: 'Google Ads Optimization',
        description: 'Analyze and optimize current ad campaigns',
        status: TaskStatus.inProgress,
        createdAt: DateTime.now().subtract(Duration(days: 4)),
        updatedAt: DateTime.now().subtract(Duration(hours: 3)),
        priority: 1,
        updates: [
          TaskUpdate(
            id: '4-1',
            description: 'Initial campaign analysis completed',
            timestamp: DateTime.now().subtract(Duration(days: 4)),
            updatedBy: 'PPC Specialist',
          ),
          TaskUpdate(
            id: '4-2',
            description: 'Keyword optimization in progress',
            timestamp: DateTime.now().subtract(Duration(hours: 3)),
            updatedBy: 'PPC Specialist',
          ),
        ],
      ),
    ];
  }

  static List<AppNotification> getNotifications() {
    return [
      AppNotification(
        id: '1',
        title: 'New Lead Generated',
        description: 'A new qualified lead from Instagram campaign',
        type: NotificationType.newLead,
        timestamp: DateTime.now().subtract(Duration(hours: 1)),
        isRead: false,
        relatedId: 'lead_123',
      ),
      AppNotification(
        id: '2',
        title: 'Task Update',
        description: 'YouTube Shorts project progress updated',
        type: NotificationType.taskUpdate,
        timestamp: DateTime.now().subtract(Duration(hours: 6)),
        isRead: false,
        relatedId: '1',
      ),
      AppNotification(
        id: '3',
        title: 'Performance Milestone',
        description: 'YouTube channel reached 2.5K subscribers!',
        type: NotificationType.milestone,
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: 'Weekly Performance Report',
        description: 'Your weekly performance metrics are ready',
        type: NotificationType.performanceUpdate,
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
      ),
      AppNotification(
        id: '5',
        title: 'Campaign Completed',
        description: 'Instagram dermatology campaign has been completed',
        type: NotificationType.taskUpdate,
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        isRead: true,
        relatedId: '2',
      ),
    ];
  }

  static Map<String, dynamic> getUserProfile() {
    return {
      'name': 'Dr. Rajesh Kumar',
      'email': 'dr.rajesh@example.com',
      'phone': '+91 98765 43210',
      'specialty': 'Cardiology',
      'clinic': 'Kumar Heart Care Clinic',
      'profileImage': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=150&h=150&fit=crop&crop=face',
      'notificationPreferences': {
        'emailNotifications': true,
        'pushNotifications': true,
        'performanceAlerts': true,
        'taskUpdates': true,
        'weeklyReports': true,
      },
    };
  }
}