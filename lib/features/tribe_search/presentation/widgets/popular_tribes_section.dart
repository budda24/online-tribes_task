import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class PopularTribesSection extends StatelessWidget {
  const PopularTribesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12.w, bottom: 12.h),
          child: Text(
            context.localizations.popularTribes,
            style: context.appTextStyles.subtitle2BOld,
          ),
        ),
        FakeTribeItem(
          headerColor: Colors.green,
          ownerColor: Colors.green[900]!,
          membersCount: 32,
        ),
        FakeTribeItem(
          headerColor: Colors.blue,
          ownerColor: Colors.blue[900]!,
          membersCount: 20,
        ),
        FakeTribeItem(
          headerColor: Colors.orange,
          ownerColor: Colors.orange[900]!,
          membersCount: 99,
        ),
        FakeTribeItem(
          headerColor: Colors.red,
          ownerColor: Colors.red[900]!,
          membersCount: 70,
        ),
        FakeTribeItem(
          headerColor: Colors.purple,
          ownerColor: Colors.purple[900]!,
          membersCount: 70,
        ),
        FakeTribeItem(
          headerColor: Colors.blueGrey,
          ownerColor: Colors.blueGrey[900]!,
          membersCount: 34,
        ),
      ],
    );
  }
}

class FakeTribeItem extends StatelessWidget {
  final Color headerColor;
  final Color ownerColor;
  final int membersCount;

  const FakeTribeItem({
    required this.headerColor,
    required this.ownerColor,
    required this.membersCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: headerColor,
            ),
            height: 120.h,
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ownerColor,
                      radius: 16.r,
                    ),
                    6.horizontalSpace,
                    Text(
                      'Tribe name',
                      style: context.appTextStyles.subtitle2BOld,
                    ),
                  ],
                ),
                12.verticalSpace,
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sit amet faucibus justo, eget scelerisque diam. Suspendisse a elit elit. Curabitur a dapibus justo',
                  style: context.appTextStyles.bodyText2
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                12.verticalSpace,
                Row(
                  children: [
                    Text(
                      '$membersCount members',
                      style: context.appTextStyles.bodyText2
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    6.horizontalSpace,
                    CircleAvatar(
                      radius: 3.r,
                      backgroundColor: context.appColors.textColor,
                    ),
                    6.horizontalSpace,
                    Text(
                      'Tribe owner name',
                      style: context.appTextStyles.bodyText2
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
