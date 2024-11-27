import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/helpers.dart';

class PostItem extends StatelessWidget {
  final String avatarUrl;
  final String author;
  final String content;
  final DateTime createdAt;

  const PostItem({
    required this.avatarUrl,
    required this.author,
    required this.content,
    required this.createdAt,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.r),
      ),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Padding(
        padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthorAvatar(avatarUrl),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: context.appTextStyles.bodyText1,
                      children: [
                        TextSpan(
                          style: context.appTextStyles.bodyText1,
                          text: '$author ',
                        ),
                        TextSpan(
                          style: context.appTextStyles.bodyText2.copyWith(
                            fontSize: 12,
                            color: context.appColors.shadowColor,
                          ),
                          text: Helpers.getTimeDifferenceFromNow(
                            createdAt,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    content,
                    style: context.appTextStyles.bodyText2,
                  ),
                  Row(
                    children: [
                      ActionButton(
                        icon: Icons.thumb_up_off_alt,
                        label: context.localizations.reaction,
                        onTap: () {},
                      ),
                      8.horizontalSpace,
                      ActionButton(
                        icon: Icons.chat_bubble_outline,
                        label: context.localizations.reply,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthorAvatar extends StatelessWidget {
  final String avatarUrl;

  const AuthorAvatar(this.avatarUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.r),
      child:
          // Uncomment when we add real posts
          // CachedNetworkImage(
          //   imageUrl: avatarUrl,
          //   height: 40.h,
          //   width: 40.w,
          //   fit: BoxFit.cover,
          //   placeholder: (context, value) => BlinkingPlaceholder(
          //     localAssetName: Assets.shared.logo.logoSquer.path,
          //   ),
          //   errorWidget: (context, url, error) => Image.asset(
          //     Assets.shared.downloadingError.path,
          //   ),
          // ),
          Image.asset(
        avatarUrl,
        height: 40.h,
        width: 40.w,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      icon: Row(
        children: [
          Icon(
            icon,
            color: context.appColors.shadowColor.withOpacity(0.5),
          ),
          4.horizontalSpace,
          Text(
            label,
            style: context.appTextStyles.bodyText2.copyWith(
              fontSize: 11,
              color: context.appColors.shadowColor.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
