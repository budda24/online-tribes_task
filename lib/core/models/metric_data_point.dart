import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/utils/json_converters.dart';

part 'metric_data_point.freezed.dart';
part 'metric_data_point.g.dart';

@freezed
class MetricDataPoint with _$MetricDataPoint {
  const factory MetricDataPoint({
    @TimestampConverter() required DateTime date,
    required double value,
  }) = _MetricDataPoint;

  factory MetricDataPoint.fromJson(Map<String, dynamic> json) =>
      _$MetricDataPointFromJson(json);
}
