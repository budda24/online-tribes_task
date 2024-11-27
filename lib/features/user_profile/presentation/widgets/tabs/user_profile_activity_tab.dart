import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/shared/widgets/profiles/fake_post.dart';
import 'package:online_tribes/features/user_profile/presentation/widgets/user_metrics_chart.dart';

class UserActivityTab extends StatefulWidget {
  final UserModel user;
  const UserActivityTab({
    required this.user,
    super.key,
  });
  @override
  State<UserActivityTab> createState() => _UserActivityTabState();
}

class _UserActivityTabState extends State<UserActivityTab> {
  @override
  Widget build(BuildContext context) {
    return StyledSingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserMetricsChart(user: widget.user),
          25.verticalSpace,
          const FakePosts(),
        ],
      ),
    );
  }
}
