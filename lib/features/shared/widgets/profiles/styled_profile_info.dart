import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/injection.dart';
import 'package:online_tribes/theme/app_colors.dart';
import 'package:online_tribes/theme/app_text_style.dart';

class StyledProfileInfoDisplay extends StatelessWidget {
  final List<ProfileInfoItem> leftColumnItems;
  final List<ProfileInfoItem> rightColumnItems;

  const StyledProfileInfoDisplay({
    required this.leftColumnItems,
    required this.rightColumnItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: leftColumnItems
                  .map(
                    (item) => _buildUserInfoItemRight(
                      item.icon,
                      item.text,
                    ),
                  )
                  .toList(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: rightColumnItems
                  .map((item) => _buildUserInfoItemLeft(item.icon, item.text))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserInfoItemRight(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: getIt<AppColors>().textColor),
          10.horizontalSpace,
          Text(
            text,
            style: getIt<AppTextStyles>().subtitle2BOld,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoItemLeft(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Text(
            text,
            style: getIt<AppTextStyles>().subtitle2BOld,
          ),
          10.horizontalSpace,
          Icon(icon, color: getIt<AppColors>().textColor),
        ],
      ),
    );
  }
}

class ProfileInfoItem {
  final IconData icon;
  final String text;

  ProfileInfoItem({
    required this.icon,
    required this.text,
  });
}
