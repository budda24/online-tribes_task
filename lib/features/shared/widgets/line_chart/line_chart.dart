import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/widgets/line_chart/metric_data.dart';

enum ChartPeriod {
  month,
}

class LineChartWidget extends StatelessWidget {
  final ChartPeriod period;
  final List<MetricData> metrics;

  LineChartWidget({
    required this.period,
    required this.metrics,
    super.key,
  }) : assert(metrics.isNotEmpty, 'metrics must not be empty');

  @override
  Widget build(BuildContext context) {
    return LineChart(
      _getLineChartData(context),
      duration: const Duration(milliseconds: 250),
    );
  }

  // Determines the chart data structure based on the selected period
  LineChartData _getLineChartData(BuildContext context) {
    switch (period) {
      case ChartPeriod.month:
        return _weeklyData(context);
    }
  }

  // Configures LineChartData for weekly period view
  LineChartData _weeklyData(BuildContext context) => LineChartData(
        lineTouchData: _lineTouchData,
        gridData: _gridData,
        titlesData: _titlesDataWeekly(context),
        borderData: _borderData,
        lineBarsData: _lineBarsData,
        minX: 0,
        maxX: 30, // Set for up to 30 days on x-axis
        minY: 0,
        maxY: 5,
      );

  // Builds line chart bars with different colors for each data set
  List<LineChartBarData> get _lineBarsData => metrics
      .map((metric) => _buildLineChartBarData(metric.spots, metric.color))
      .toList();

  // Configures each line chart bar's appearance and data points
  LineChartBarData _buildLineChartBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      isCurved: true,
      color: color,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      barWidth: 5,
      belowBarData: BarAreaData(),
      spots: spots,
    );
  }

  // Sets titles data for weekly view with customized x and y axis titles
  FlTitlesData _titlesDataWeekly(BuildContext context) => FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: _bottomTitlesWeekly(context)),
        leftTitles: AxisTitles(sideTitles: _leftTitles(context)),
      );

  // Customizes the x-axis labels for weekly view
  SideTitles _bottomTitlesWeekly(BuildContext context) => SideTitles(
        interval: 3, // Labels shown every 3 units
        getTitlesWidget: (value, meta) {
          return Text(
            '${value.toInt()}', // Show integer value as label
            style: context.appTextStyles.overline,
            textAlign: TextAlign.center,
          );
        },
      );

  // Configures the y-axis labels with localized suffix for points
  SideTitles _leftTitles(BuildContext context) => SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          return Text(
            '${value.toInt()}${context.localizations.engageMetricsPointsSuffix}',
            style: context.appTextStyles.overline,
            textAlign: TextAlign.center,
          );
        },
      );

  // Hides grid lines on the chart
  FlGridData get _gridData => const FlGridData(show: false);

  // Configures chart border display settings
  FlBorderData get _borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(),
        ),
      );

  // Enables line touch interactions on the chart
  LineTouchData get _lineTouchData => const LineTouchData();
}
