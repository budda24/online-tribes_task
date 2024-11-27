import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/post_item.dart';
import 'package:online_tribes/gen/assets.gen.dart';

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
