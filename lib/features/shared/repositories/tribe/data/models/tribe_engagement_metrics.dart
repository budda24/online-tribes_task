import 'dart:math';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/models/metric_data_point.dart';

part 'tribe_engagement_metrics.g.dart';
part 'tribe_engagement_metrics.freezed.dart';

@freezed
class TribeEngageMetrics with _$TribeEngageMetrics {
  const factory TribeEngageMetrics({
    required List<MetricDataPoint> likesOverTime,
    required List<MetricDataPoint> commentsOverTime,
    required List<MetricDataPoint> sharesOverTime,
    required List<MetricDataPoint> activeConversationsOverTime,
    required List<MetricDataPoint> averageMessagesPerConversationOverTime,
    required List<MetricDataPoint> averageMessagesPerGroupChatOverTime,
    required List<MetricDataPoint> storiesPostedOverTime,
    required List<MetricDataPoint> tribersParticipationOverTime,
    required List<MetricDataPoint> averageResponseTimeOverTime,
  }) = _TribeEngageMetrics;

  const TribeEngageMetrics._();

  static double findMinValue(List<MetricDataPoint> dataPoints) {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.map((dp) => dp.value).reduce(min);
  }

  static double findMaxValue(List<MetricDataPoint> dataPoints) {
    if (dataPoints.isEmpty) return 0;
    return dataPoints.map((dp) => dp.value).reduce(max);
  }

  /// Aggregates engagement-related metrics into a single list by summing their values on matching dates.
  List<MetricDataPoint> get getTotalEngagementOverTime {
    return _mergeDataPointsByDate([
      likesOverTime,
      commentsOverTime,
      sharesOverTime,
    ]);
  }

  /// Aggregates conversation-related metrics into a single list by summing their values on matching dates.
  List<MetricDataPoint> get getTotalOngoingConversationsOverTime {
    return _mergeDataPointsByDate([
      activeConversationsOverTime,
      averageMessagesPerConversationOverTime,
      averageMessagesPerGroupChatOverTime,
    ]);
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

  /// Generates test data points for the metrics.
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

  /// Populates the metrics with test data.
  factory TribeEngageMetrics.populateWithTestData() {
    return TribeEngageMetrics(
      likesOverTime: generateTestDataPoints(
        days: 90,
        startValue: 100,
        fluctuationRange: 20,
        trend: 0.5,
        seasonalityAmplitude: 10,
      ),
      commentsOverTime: generateTestDataPoints(
        days: 90,
        startValue: 50,
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
      activeConversationsOverTime: generateTestDataPoints(
        days: 90,
        startValue: 60,
        fluctuationRange: 10,
        trend: 0.2,
        seasonalityAmplitude: 5,
      ),
      averageMessagesPerConversationOverTime: generateTestDataPoints(
        days: 90,
        startValue: 15,
        fluctuationRange: 3,
        trend: 0.05,
        seasonalityAmplitude: 1,
      ),
      averageMessagesPerGroupChatOverTime: generateTestDataPoints(
        days: 90,
        startValue: 10,
        fluctuationRange: 2,
        trend: 0.03,
        seasonalityAmplitude: 0.5,
      ),
      storiesPostedOverTime: generateTestDataPoints(
        days: 90,
        startValue: 20,
        fluctuationRange: 5,
        trend: 0.1,
        seasonalityAmplitude: 2,
      ),
      tribersParticipationOverTime: generateTestDataPoints(
        days: 90,
        startValue: 70,
        fluctuationRange: 15,
        trend: 0.4,
        seasonalityAmplitude: 7,
      ),
      averageResponseTimeOverTime: generateTestDataPoints(
        days: 90,
        startValue: 2.5,
        fluctuationRange: 0.5,
        trend: -0.01,
        seasonalityAmplitude: 0.1,
      ),
    );
  }

  factory TribeEngageMetrics.fromJson(Map<String, dynamic> json) =>
      _$TribeEngageMetricsFromJson(json);
}
