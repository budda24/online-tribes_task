import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_engagement_metrics.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/widgets/line_chart/line_chart.dart';
import 'package:online_tribes/features/shared/widgets/line_chart/metric_data.dart';
import 'package:online_tribes/features/user_profile/domain/service/user_metrics_service.dart';
import 'package:online_tribes/theme/metrics_colors.dart';

class UserMetricsChart extends StatefulWidget {
  final UserModel user;

  const UserMetricsChart({required this.user, super.key});

  @override
  State<UserMetricsChart> createState() => _UserMetricsChartState();
}

class _UserMetricsChartState extends State<UserMetricsChart> {
  late final UserMetricsService _metricsService;
  late UserEngagementMetrics _userMetrics;

  ChartPeriod selectedPeriod = ChartPeriod.month;

  List<FlSpot> spotsConversations = [];
  List<FlSpot> spotsEngagement = [];
  List<FlSpot> spotsTimeSpend = [];

  @override
  void initState() {
    super.initState();
    _metricsService = UserMetricsService();
    _userMetrics = UserEngagementMetrics.populateWithTestData();
    _updateChartData();
  }

  void _updateChartData() {
    spotsConversations = _metricsService.getFlSpotsForMetric(
      _userMetrics.getTotalOngoingConversationsOverTime,
      selectedPeriod,
    ); //green
    spotsEngagement = _metricsService.getFlSpotsForMetric(
      _userMetrics.getTotalEngagementOverTime,
      selectedPeriod,
    ); //purple
    spotsTimeSpend = _metricsService.getFlSpotsForMetric(
      _userMetrics.getTotalMinutesSpentInTribesOverTime,
      selectedPeriod,
    ); //cyan
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
              MetricData(
                spots: spotsConversations,
                color: MetricColors.conversations,
              ),
              MetricData(
                spots: spotsEngagement,
                color: MetricColors.engagement,
              ),
              MetricData(
                spots: spotsTimeSpend,
                color: MetricColors.timeSpend,
              ),
            ],
          ),
        ),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              MetricColors.conversations,
              context.localizations.engageMetricsConversations,
            ),
            SizedBox(width: 20.w),
            _buildLegendItem(
              MetricColors.engagement,
              context.localizations.engageMetricsEngagement,
            ),
            SizedBox(width: 20.w),
            _buildLegendItem(
              MetricColors.timeSpend,
              context.localizations.engageMetricsTimeSpent,
            ),
          ],
        ),
      ],
    );
  }
}
