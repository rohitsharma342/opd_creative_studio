class PerformanceMetrics {
  final YouTubeMetrics youtube;
  final SocialMediaMetrics socialMedia;
  final LeadsMetrics leads;
  final DateTime lastUpdated;

  PerformanceMetrics({
    required this.youtube,
    required this.socialMedia,
    required this.leads,
    required this.lastUpdated,
  });

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      youtube: YouTubeMetrics.fromJson(json['youtube']),
      socialMedia: SocialMediaMetrics.fromJson(json['socialMedia']),
      leads: LeadsMetrics.fromJson(json['leads']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}

class YouTubeMetrics {
  final int shortsPosted;
  final int totalViews;
  final int subscribers;
  final double avgViewDuration;
  final List<ChartData> viewsChart;
  final List<ChartData> subscribersChart;

  YouTubeMetrics({
    required this.shortsPosted,
    required this.totalViews,
    required this.subscribers,
    required this.avgViewDuration,
    required this.viewsChart,
    required this.subscribersChart,
  });

  factory YouTubeMetrics.fromJson(Map<String, dynamic> json) {
    return YouTubeMetrics(
      shortsPosted: json['shortsPosted'],
      totalViews: json['totalViews'],
      subscribers: json['subscribers'],
      avgViewDuration: json['avgViewDuration'].toDouble(),
      viewsChart: (json['viewsChart'] as List)
          .map((data) => ChartData.fromJson(data))
          .toList(),
      subscribersChart: (json['subscribersChart'] as List)
          .map((data) => ChartData.fromJson(data))
          .toList(),
    );
  }
}

class SocialMediaMetrics {
  final int instagramFollowers;
  final int facebookFollowers;
  final int linkedinFollowers;
  final int totalEngagement;
  final List<ChartData> followersChart;
  final List<ChartData> engagementChart;

  SocialMediaMetrics({
    required this.instagramFollowers,
    required this.facebookFollowers,
    required this.linkedinFollowers,
    required this.totalEngagement,
    required this.followersChart,
    required this.engagementChart,
  });

  factory SocialMediaMetrics.fromJson(Map<String, dynamic> json) {
    return SocialMediaMetrics(
      instagramFollowers: json['instagramFollowers'],
      facebookFollowers: json['facebookFollowers'],
      linkedinFollowers: json['linkedinFollowers'],
      totalEngagement: json['totalEngagement'],
      followersChart: (json['followersChart'] as List)
          .map((data) => ChartData.fromJson(data))
          .toList(),
      engagementChart: (json['engagementChart'] as List)
          .map((data) => ChartData.fromJson(data))
          .toList(),
    );
  }

  int get totalFollowers =>
      instagramFollowers + facebookFollowers + linkedinFollowers;
}

class LeadsMetrics {
  final int totalLeads;
  final int qualifiedLeads;
  final int convertedLeads;
  final double conversionRate;
  final List<ChartData> leadsChart;
  final List<PieChartData> leadsSourceChart;

  LeadsMetrics({
    required this.totalLeads,
    required this.qualifiedLeads,
    required this.convertedLeads,
    required this.conversionRate,
    required this.leadsChart,
    required this.leadsSourceChart,
  });

  factory LeadsMetrics.fromJson(Map<String, dynamic> json) {
    return LeadsMetrics(
      totalLeads: json['totalLeads'],
      qualifiedLeads: json['qualifiedLeads'],
      convertedLeads: json['convertedLeads'],
      conversionRate: json['conversionRate'].toDouble(),
      leadsChart: (json['leadsChart'] as List)
          .map((data) => ChartData.fromJson(data))
          .toList(),
      leadsSourceChart: (json['leadsSourceChart'] as List)
          .map((data) => PieChartData.fromJson(data))
          .toList(),
    );
  }
}

class ChartData {
  final String label;
  final double value;
  final DateTime? date;

  ChartData({
    required this.label,
    required this.value,
    this.date,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['label'],
      value: json['value'].toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}

class PieChartData {
  final String label;
  final double value;
  final String color;

  PieChartData({
    required this.label,
    required this.value,
    required this.color,
  });

  factory PieChartData.fromJson(Map<String, dynamic> json) {
    return PieChartData(
      label: json['label'],
      value: json['value'].toDouble(),
      color: json['color'],
    );
  }
}