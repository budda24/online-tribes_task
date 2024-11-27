import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/fake_translation.dart';
import 'package:online_tribes/gen/assets.gen.dart';

class UserStatusCard extends StatelessWidget {
  final String name;
  final bool status;
  final String joinedDate;
  final String location;
  final String imageUrl;

  const UserStatusCard({
    required this.name,
    required this.status,
    required this.joinedDate,
    required this.location,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                imageUrl,
              ),
              backgroundColor: Colors.grey,
            ),
            16.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.verticalSpace,
                Text(
                  name,
                  style: context.appTextStyles.bodyText1.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                8.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 14,
                      color: status
                          ? context.appColors.successColor
                          : context.appColors.disabledColor,
                    ),
                    8.horizontalSpace,
                    Text(
                      status
                          ? fakeTranslation('online now')
                          : fakeTranslation('offline'),
                      style: context.appTextStyles.subtitle2,
                    ),
                  ],
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: context.appColors.textColor,
                    ),
                    8.horizontalSpace,
                    Text(
                      joinedDate,
                      style: context.appTextStyles.subtitle2,
                    ),
                  ],
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: context.appColors.textColor,
                    ),
                    8.horizontalSpace,
                    Text(
                      location,
                      style: context.appTextStyles.subtitle2,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            // TODO(sadji): implement on press
          },
          style: IconButton.styleFrom(
            backgroundColor: context.appColors.disabledColor,
          ),
          tooltip: fakeTranslation('Send message'),
          icon: SvgPicture.asset(
            Assets.shared.icons.message.path,
          ),
        ),
      ],
    );
  }
}
