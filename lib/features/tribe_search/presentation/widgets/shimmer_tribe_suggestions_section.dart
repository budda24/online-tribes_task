import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTribeSuggestionsSection extends StatelessWidget {
  const ShimmerTribeSuggestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.appColors.shimmerBaseColor,
      highlightColor: context.appColors.shimmerHighlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 12.h),
            child: Text(
              'Looking for tribes...',
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
        ],
      ),
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
            height: 110.h,
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 160.w,
                  height: 15.h,
                  color: Colors.black,
                ),
                12.verticalSpace,
                Container(
                  width: double.infinity,
                  height: 8.h,
                  color: Colors.black,
                ),
                4.verticalSpace,
                Container(
                  width: double.infinity,
                  height: 8.h,
                  color: Colors.black,
                ),
                4.verticalSpace,
                Container(
                  width: double.infinity,
                  height: 8.h,
                  color: Colors.black,
                ),
                4.verticalSpace,
                Container(
                  width: double.infinity,
                  height: 8.h,
                  color: Colors.black,
                ),
                12.verticalSpace,
                Row(
                  children: [
                    Container(
                      width: 70.w,
                      height: 10.h,
                      color: Colors.black,
                    ),
                    6.horizontalSpace,
                    CircleAvatar(
                      radius: 3.r,
                      backgroundColor: context.appColors.textColor,
                    ),
                    6.horizontalSpace,
                    Container(
                      width: 70.w,
                      height: 10.h,
                      color: Colors.black,
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
