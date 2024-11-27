import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_tribes.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_single_child_scroll_view.dart';
import 'package:online_tribes/features/user_profile/presentation/widgets/tribe_list.dart';

class UserTribesTab extends StatelessWidget {
  final UserTribes userTribes;
  final UserModel user;

  const UserTribesTab({
    required this.userTribes,
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return StyledSingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),
            Text(
              'Created by ${user.username}:',
              style: textStyles.subtitle2BOld,
            ),
            SizedBox(height: 15.h),
            TribeList(
              tribes: userTribes.ownedTribes,
              emptyMessage: 'No tribes created by ${user.username}.',
            ),
            SizedBox(height: 20.h),
            Text(
              'Memberships:',
              style: textStyles.subtitle2BOld,
            ),
            TribeList(
              tribes: userTribes.memberTribes,
              emptyMessage: '${user.username} is not a member of any tribes.',
            ),
          ],
        ),
      ),
    );
  }
}
