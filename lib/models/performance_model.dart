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
}

class ChartData {
  final String label;
  final double value;
  final DateTime date;

  ChartData({
    required this.label,
    required this.value,
    required this.date,
  });
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
}