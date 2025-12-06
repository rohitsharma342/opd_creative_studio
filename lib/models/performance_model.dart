class PerformanceModel {
  final int youtubeShorts;
  final int totalViews;
  final int followers;
  final int leads;
  final List<ChartData> viewsChart;
  final List<ChartData> followersChart;
  final List<PieChartData> leadsChart;

  PerformanceModel({
    required this.youtubeShorts,
    required this.totalViews,
    required this.followers,
    required this.leads,
    required this.viewsChart,
    required this.followersChart,
    required this.leadsChart,
  });

  factory PerformanceModel.fromJson(Map<String, dynamic> json) {
    return PerformanceModel(
      youtubeShorts: json['youtubeShorts'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      followers: json['followers'] ?? 0,
      leads: json['leads'] ?? 0,
      viewsChart: (json['viewsChart'] as List<dynamic>? ?? [])
          .map((e) => ChartData.fromJson(e))
          .toList(),
      followersChart: (json['followersChart'] as List<dynamic>? ?? [])
          .map((e) => ChartData.fromJson(e))
          .toList(),
      leadsChart: (json['leadsChart'] as List<dynamic>? ?? [])
          .map((e) => PieChartData.fromJson(e))
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
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}

class PieChartData {
  final String label;
  final double value;
  final int color;

  PieChartData({
    required this.label,
    required this.value,
    required this.color,
  });

  factory PieChartData.fromJson(Map<String, dynamic> json) {
    return PieChartData(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      color: json['color'] ?? 0xFF000000,
    );
  }
}
