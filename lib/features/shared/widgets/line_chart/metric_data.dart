import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

@immutable
class MetricData {
  final List<FlSpot> spots;
  final Color color;

  const MetricData({
    required this.spots,
    required this.color,
  });
}
