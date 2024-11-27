import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/helpers.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/enum/tribe_membership_ticket_status.dart';
import 'package:online_tribes/features/shared/widgets/images/rounded_avatar.dart';
import 'package:shimmer/shimmer.dart';

class TribeMembershipTicketItem extends StatelessWidget {
  final String senderAvatarUrl;
  final String senderName;
  final String message;
  final DateTime createdAt;
  final TribeMembershipTicketStatus status;
  final VoidCallback onAccept;
  final VoidCallback onDeny;

  const TribeMembershipTicketItem({
    required this.senderAvatarUrl,
    required this.senderName,
    required this.message,
    required this.createdAt,
    required this.status,
    required this.onAccept,
    required this.onDeny,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      isEnabled: status == TribeMembershipTicketStatus.inProgress,
      child: Padding(
        padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                RoundedAvatar(senderAvatarUrl),
                8.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        senderName,
                        style: context.appTextStyles.bodyText1,
                      ),
                      Text(
                        Helpers.getTimeDifferenceFromNow(
                          createdAt,
                          context: context,
                        ),
                        style: context.appTextStyles.bodyText2.copyWith(
                          fontSize: 12,
                          color: context.appColors.shadowColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Text(
              message,
              style: context.appTextStyles.bodyText2,
            ),
            4.verticalSpace,
            Row(
              children: [
                const Spacer(),
                ActionButton(
                  label: context.localizations.accept,
                  onTap: onAccept,
                ),
                8.horizontalSpace,
                ActionButton(
                  label: context.localizations.deny,
                  onTap: onDeny,
                ),
                22.horizontalSpace,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerWrapper extends StatelessWidget {
  final bool isEnabled;
  final Widget child;

  const ShimmerWrapper({
    required this.isEnabled,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isEnabled) {
      return Shimmer.fromColors(
        baseColor: context.appColors.shimmerBaseColor,
        highlightColor: context.appColors.shimmerHighlightColor,
        child: child,
      );
    } else {
      return child;
    }
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      icon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Text(
          label,
          style: context.appTextStyles.bodyText2
              .copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
