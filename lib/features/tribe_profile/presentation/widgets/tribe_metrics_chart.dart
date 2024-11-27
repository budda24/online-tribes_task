import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/fake_translation.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_engagement_metrics.dart';
import 'package:online_tribes/features/shared/widgets/line_chart/line_chart.dart';
import 'package:online_tribes/features/shared/widgets/line_chart/metric_data.dart';
import 'package:online_tribes/features/tribe_profile/domain/tribe_metrics_service.dart';
import 'package:online_tribes/theme/metrics_colors.dart';

class TribeMetricsChart extends StatefulWidget {
  const TribeMetricsChart({super.key});

  @override
  State<TribeMetricsChart> createState() => _TribeMetricsChartState();
}

class _TribeMetricsChartState extends State<TribeMetricsChart> {
  late final TribeMetricsService _metricsService;
  late TribeEngageMetrics _tribeMetrics;

  ChartPeriod selectedPeriod = ChartPeriod.month;

  List<FlSpot> spotsConversations = [];
  List<FlSpot> spotsEngagement = [];
  List<FlSpot> spotsStories = [];

  @override
  void initState() {
    super.initState();
    _metricsService = TribeMetricsService();
    _tribeMetrics = TribeEngageMetrics.populateWithTestData();
    _updateChartData();
  }

  void _updateChartData() {
    spotsConversations = _metricsService.getFlSpotsForMetric(
      _tribeMetrics.getTotalOngoingConversationsOverTime,
      selectedPeriod,
    ); // green
    spotsEngagement = _metricsService.getFlSpotsForMetric(
      _tribeMetrics.getTotalEngagementOverTime,
      selectedPeriod,
    ); // purple
    spotsStories = _metricsService.getFlSpotsForMetric(
      _tribeMetrics.storiesPostedOverTime,
      selectedPeriod,
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: color,
          width: 12.w,
          height: 12.h,
        ),
        SizedBox(width: 8.w),
        FittedBox(
          child: Text(
            label,
            style: context.appTextStyles.overline,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        ToggleButtons(
          isSelected: [
            selectedPeriod == ChartPeriod.month,
          ],
          onPressed: (index) {
            setState(() {
              selectedPeriod = ChartPeriod.values[index];
              _updateChartData();
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.localizations.engageMetricsLast30Days,
                style: context.appTextStyles.subtitle2,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 0.20.sh,
          child: LineChartWidget(
            period: selectedPeriod,
            metrics: [
              MetricData(spots: spotsConversations, color: Colors.green),
              MetricData(spots: spotsEngagement, color: Colors.purple),
              MetricData(spots: spotsStories, color: Colors.orange),
            ],
          ),
        ),
        10.verticalSpace,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                MetricColors.conversations,
                context.localizations.tribeMetricsConversations,
              ),
              20.horizontalSpace,
              _buildLegendItem(
                MetricColors.engagement,
                context.localizations.tribeMetricsEngagement,
              ),
              20.horizontalSpace,
              _buildLegendItem(
                MetricColors.stories,
                fakeTranslation('Shorts'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
