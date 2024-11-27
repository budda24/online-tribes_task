import 'dart:math';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/models/metric_data_point.dart';

part 'user_engagement_metrics.freezed.dart';
part 'user_engagement_metrics.g.dart';

/// Represents various user engagement metrics tracked over time.
/// Utilizes the Freezed package for immutable data classes and JSON serialization.
@freezed
class UserEngagementMetrics with _$UserEngagementMetrics {
  /// Factory constructor for [UserEngagementMetrics].
  /// Each metric is a list of [MetricDataPoint], representing the metric's value on specific dates.
  const factory UserEngagementMetrics({
    required List<MetricDataPoint> activeConversationsOverTime,
    required List<MetricDataPoint> averageMessagesPerConversationOverTime,
    required List<MetricDataPoint> averageMessagesPerGroupChatOverTime,
    required List<MetricDataPoint> likesOverTime,
    required List<MetricDataPoint> commentsOverTime,
    required List<MetricDataPoint> sharesOverTime,
    required List<MetricDataPoint> totalMinutesSpentInTribesOverTime,
    required List<MetricDataPoint> growthOverTime,
  }) = _UserEngagementMetrics;

  const UserEngagementMetrics._();

  static double findMinValue(List<MetricDataPoint> dataPoints) {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.map((dp) => dp.value).reduce(min);
  }

  static double findMaxValue(List<MetricDataPoint> dataPoints) {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.map((dp) => dp.value).reduce(max);
  }

  /// Aggregates conversation-related metrics into a single list by summing their values on matching dates.
  List<MetricDataPoint> get getTotalOngoingConversationsOverTime {
    return _mergeDataPointsByDate([
      activeConversationsOverTime,
      averageMessagesPerConversationOverTime,
      averageMessagesPerGroupChatOverTime,
    ]);
  }

  /// Aggregates engagement-related metrics into a single list by summing their values on matching dates.
  List<MetricDataPoint> get getTotalEngagementOverTime {
    return _mergeDataPointsByDate([
      likesOverTime,
      commentsOverTime,
      sharesOverTime,
    ]);
  }

  /// Retrieves the total minutes spent in tribes over time.
  /// Directly maps from `totalMinutesSpentInTribesOverTime`.
  List<MetricDataPoint> get getTotalMinutesSpentInTribesOverTime {
    return totalMinutesSpentInTribesOverTime;
  }

  /// Sums the values for the same date and returns a sorted list.
  static List<MetricDataPoint> _mergeDataPointsByDate(
    List<List<MetricDataPoint>> dataPointLists,
  ) {
    final dateToValueMap = <DateTime, double>{};

    for (final dataPoints in dataPointLists) {
      for (final dp in dataPoints) {
        final date = dp.date;
        // Sum values for the same date or initialize if the date is not present.
        dateToValueMap.update(
          date,
          (value) => value + dp.value,
          ifAbsent: () => dp.value,
        );
      }
    }

    // Convert the map to a list of MetricDataPoint and sort by date.
    final mergedDataPoints = dateToValueMap.entries
        .map((entry) => MetricDataPoint(date: entry.key, value: entry.value))
        .toList();

    // ignore: cascade_invocations
    mergedDataPoints.sort((a, b) => a.date.compareTo(b.date));

    return mergedDataPoints;
  }

  static List<MetricDataPoint> generateTestDataPoints({
    required int days,
    required double startValue,
    required double fluctuationRange,
    double trend = 0,
    double seasonalityAmplitude = 0,
    int seasonalityPeriod = 7,
    double spikeProbability = 0,
    double spikeMagnitude = 0,
  }) {
    final dataPoints = <MetricDataPoint>[];
    final now = DateTime.now();
    final random = Random();

    for (var i = 0; i < days; i++) {
      // Normalize the date to midnight for consistency.
      final date = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: days - i - 1));

      // Calculate the value with trend, seasonality, and random fluctuation.
      var value = startValue + trend * i;

      // Add seasonal variation if applicable.
      if (seasonalityAmplitude > 0 && seasonalityPeriod > 0) {
        value += seasonalityAmplitude * sin(2 * pi * i / seasonalityPeriod);
      }

      // Add random fluctuation within the specified range.
      value += random.nextDouble() * fluctuationRange - (fluctuationRange / 2);

      // Introduce occasional spikes based on probability.
      if (spikeProbability > 0 && random.nextDouble() < spikeProbability) {
        value += (random.nextBool() ? 1 : -1) * spikeMagnitude;
      }

      // Ensure the metric value does not go negative.
      value = max(0, value);

      // Create and add the data point to the list.
      dataPoints.add(MetricDataPoint(date: date, value: value));
    }
    return dataPoints;
  }

  factory UserEngagementMetrics.populateWithTestData() {
    return UserEngagementMetrics(
      activeConversationsOverTime: generateTestDataPoints(
        days: 90,
        startValue: 50,
        fluctuationRange: 10,
        trend: 0.2,
        seasonalityAmplitude: 5,
        spikeProbability: 0.05,
        spikeMagnitude: 15,
      ),
      averageMessagesPerConversationOverTime: generateTestDataPoints(
        days: 90,
        startValue: 12.5,
        fluctuationRange: 3,
        trend: 0.05,
        seasonalityAmplitude: 1,
      ),
      averageMessagesPerGroupChatOverTime: generateTestDataPoints(
        days: 90,
        startValue: 8.3,
        fluctuationRange: 2,
        trend: 0.03,
        seasonalityAmplitude: 0.5,
      ),
      likesOverTime: generateTestDataPoints(
        days: 90,
        startValue: 80,
        fluctuationRange: 20,
        trend: 0.5,
        seasonalityAmplitude: 10,
      ),
      commentsOverTime: generateTestDataPoints(
        days: 90,
        startValue: 40,
        fluctuationRange: 15,
        trend: 0.3,
        seasonalityAmplitude: 5,
      ),
      sharesOverTime: generateTestDataPoints(
        days: 90,
        startValue: 30,
        fluctuationRange: 10,
        trend: 0.2,
        seasonalityAmplitude: 4,
      ),
      totalMinutesSpentInTribesOverTime: generateTestDataPoints(
        days: 90,
        startValue: 1200,
        fluctuationRange: 200,
        trend: 5,
        seasonalityAmplitude: 100,
        spikeProbability: 0.05,
        spikeMagnitude: 300,
      ),
      growthOverTime: generateTestDataPoints(
        days: 90,
        startValue: 5.6,
        fluctuationRange: 1,
        trend: 0.1,
        seasonalityAmplitude: 0.3,
      ),
    );
  }

  factory UserEngagementMetrics.fromJson(Map<String, dynamic> json) =>
      _$UserEngagementMetricsFromJson(json);
}
