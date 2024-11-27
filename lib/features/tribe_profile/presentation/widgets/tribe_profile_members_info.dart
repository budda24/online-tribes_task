import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/models/user_info.dart';
import 'package:online_tribes/features/shared/widgets/images/rounded_avatar.dart';

class TribeProfileMembersInfo extends StatelessWidget {
  final String ownerName;
  final List<UserInfo>? members;

  const TribeProfileMembersInfo(
    this.members, {
    required this.ownerName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Text(
            ownerName,
            style: context.appTextStyles.bodyText1,
          ),
          const Spacer(),
          if (members == null || members!.isEmpty)
            const SizedBox()
          else
            Wrap(
              spacing: -8.w,
              children: [
                ...members!.take(5).map(
                      (member) => RoundedAvatar(
                        member.profilePictureUrl,
                      ),
                    ),
              ],
            ),
          if (members == null || members!.isEmpty || members!.length <= 5)
            const SizedBox()
          else
            Text(
              '  +${members!.length - 5}',
              style: context.appTextStyles.bodyText1,
            ),
        ],
      ),
    );
  }
}
