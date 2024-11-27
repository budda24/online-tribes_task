import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/models/enum/tribe_profile_visitor_status.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/models/tribe_profile_data.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_cubit.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/post_item.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tribe_metrics_chart.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:online_tribes/router/app_routes.dart';
import 'package:online_tribes/theme/theme_context_extantion.dart';

class TribeProfileActivityTab extends StatelessWidget {
  final TribeProfileData stateData;

  const TribeProfileActivityTab(
    this.stateData, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMembershipTicketsInfo(),
        const FakePosts(),
        4.verticalSpace,
      ],
    );
  }

  Widget _buildMembershipTicketsInfo() {
    if (!stateData.visitorStatus.isOwner) {
      return const SizedBox.shrink();
    }

    if (stateData.pendingTickets.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return MembershipTicketsInfo(stateData);
    }
  }
}

class FakePosts extends StatelessWidget {
  const FakePosts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.amber.shade200,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Row(
              children: [
                16.horizontalSpace,
                SvgPicture.asset(Assets.shared.icons.pinIcon.path),
              ],
            ),
          ),
        ),
        const TribeMetricsChart(),
        8.verticalSpace,
        PostItem(
          avatarUrl: Assets.shared.fakeUserAvatar.fakeAvatarFranek.path,
          author: 'Franek Boy',
          content:
              'Let’s get to know each other! Comment below, sharing your favorite book!',
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        PostItem(
          avatarUrl: Assets.shared.fakeUserAvatar.fakeAvatarJungla.path,
          author: 'Jungla',
          content:
              'One of the most critical aspects of self-defense is trusting your guts and doing something like that like that mad',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    );
  }
}

class MembershipTicketsInfo extends StatelessWidget {
  final TribeProfileData stateData;

  const MembershipTicketsInfo(
    this.stateData, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.appColors.primaryColorLight.withOpacity(0.2),
      onTap: () {
        TribeMembershipTicketsRoute(
          $extra: context.read<TribeProfileCubit>(),
        ).push<void>(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 10.r,
              backgroundColor: context.colorScheme.primary,
              child: Text(
                '${stateData.pendingTickets.length}',
                style: context.appTextStyles.bodyText1.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
            6.horizontalSpace,
            Text(
              context.localizations.pendingJoinRequests,
              style: context.appTextStyles.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
