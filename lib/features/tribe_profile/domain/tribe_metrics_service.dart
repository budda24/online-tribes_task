import 'package:fl_chart/fl_chart.dart';
import 'package:online_tribes/core/models/metric_data_point.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_engagement_metrics.dart';
import 'package:online_tribes/features/shared/widgets/line_chart/line_chart.dart';

class TribeMetricsService {
  List<MetricDataPoint> filterDataPointsByPeriod(
    List<MetricDataPoint> dataPoints,
    ChartPeriod period,
  ) {
    if (dataPoints.isEmpty) {
      return [];
    }
    final now = DateTime.now();
    DateTime cutoffDate;

    switch (period) {
      case ChartPeriod.month:
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      // ignore: no_default_cases
      default:
        throw ArgumentError('Unsupported ChartPeriod: $period');
    }

    // Return data points after the cutoff date
    return dataPoints.where((dp) => dp.date.isAfter(cutoffDate)).toList();
  }

  // Aggregates data points into weekly averages for the last 5 weeks
  List<MetricDataPoint> aggregateDataPointsWeekly(
    List<MetricDataPoint> dataPoints,
  ) {
    if (dataPoints.isEmpty) {
      return [];
    }

    final now = DateTime.now();
    final weekYearToValues = <String, List<double>>{};

    // Filter data to include only the past 5 weeks (approximately 35 days)
    final fiveWeeksAgo = now.subtract(const Duration(days: 35));
    final recentDataPoints =
        dataPoints.where((point) => point.date.isAfter(fiveWeeksAgo)).toList();

    // Group values by week identifier (year-weekNumber) for averaging
    for (final point in recentDataPoints) {
      final weekNumber = _getWeekOfYear(point.date);
      final year = point.date.year;
      final weekIdentifier =
          '$year-$weekNumber'; // Unique identifier for year and week
      weekYearToValues.putIfAbsent(weekIdentifier, () => []).add(point.value);
    }

    // Calculate weekly averages and create data points for the last 5 weeks
    final aggregatedPoints = weekYearToValues.entries.map((entry) {
      final parts = entry.key.split('-');
      final year = int.parse(parts[0]);
      final weekNumber = int.parse(parts[1]);
      final averageValue =
          entry.value.reduce((a, b) => a + b) / entry.value.length;
      final weekStartDate = _getDateOfWeek(year, weekNumber);
      return MetricDataPoint(date: weekStartDate, value: averageValue);
    }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return aggregatedPoints.reversed.take(5).toList();
  }

  // Returns the ISO 8601 week number for the given date
  int _getWeekOfYear(DateTime date) {
    // Adjust to Thursday in current week to determine the year
    final thursday = date.add(Duration(days: 4 - date.weekday));

    // First Thursday of the year
    final firstThursday = DateTime(thursday.year, 1, 4);

    // Calculate the number of weeks between the first Thursday and the current Thursday
    return 1 + ((thursday.difference(firstThursday).inDays) / 7).floor();
  }

  // Calculates the starting date for a given week number and year based on ISO 8601
  DateTime _getDateOfWeek(int year, int weekNumber) {
    // ISO 8601 weeks start on Monday
    // Find the first Thursday of the year
    final firstThursday = DateTime(year, 1, 4);

    // Calculate the first Monday of the first week
    final firstWeekday = firstThursday.weekday;
    final firstMonday =
        firstThursday.subtract(Duration(days: firstWeekday - 1));

    // Calculate the start date of the desired week
    return firstMonday.add(Duration(days: (weekNumber - 1) * 7));
  }

  // Generates a list of FlSpot points from data points using normalized values
  List<FlSpot> generateFlSpots(
    List<MetricDataPoint> dataPoints,
    double minValue,
    double maxValue,
  ) {
    // Sort data points by date and use the first date as a reference for x-values
    dataPoints.sort((a, b) => a.date.compareTo(b.date));
    final startDate = dataPoints.first.date;

    // Map each data point to FlSpot with normalized y-values
    return dataPoints.map((dataPoint) {
      final daysSinceStart =
          dataPoint.date.difference(startDate).inDays.toDouble();
      final mappedValue = normalizeToScale(dataPoint.value, minValue, maxValue);
      return FlSpot(daysSinceStart, mappedValue);
    }).toList();
  }

  // Main method to get FlSpot list for a specific metric based on the selected period
  List<FlSpot> getFlSpotsForMetric(
    List<MetricDataPoint> dataPoints,
    ChartPeriod period,
  ) {
    // Aggregate data into weekly averages for the last 5 weeks
    final aggregatedDataPoints = aggregateDataPointsWeekly(dataPoints);

    if (aggregatedDataPoints.isEmpty) {
      return [];
    }

    // Determine min and max values for normalization
    final minValue = TribeEngageMetrics.findMinValue(aggregatedDataPoints);
    final maxValue = TribeEngageMetrics.findMaxValue(aggregatedDataPoints);

    // Generate FlSpot points from normalized data
    return generateFlSpots(aggregatedDataPoints, minValue, maxValue);
  }

  // Normalizes a value to a 0 to 5 scale based on min and max values
  double normalizeToScale(
    double value,
    double minValue,
    double maxValue,
  ) {
    if (maxValue - minValue == 0) return 0; // Avoid division by zero
    final normalized = ((value - minValue) / (maxValue - minValue)) * 5.0;

    // Ensure value is within the 0.0 to 5.0 range and round to 1 decimal place
    final clamped = normalized.clamp(0.0, 5.0);
    return double.parse(clamped.toStringAsFixed(1));
  }
}
