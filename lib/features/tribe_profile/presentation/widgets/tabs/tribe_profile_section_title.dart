import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class TribeProfileSectionTitle extends StatelessWidget {
  final String title;

  const TribeProfileSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: RichText(
        text: TextSpan(
          style: context.appTextStyles.subtitle2BOld,
          children: [
            TextSpan(
              style: context.appTextStyles.subtitle2BOld.copyWith(
                color: context.appColors.primaryColor,
                fontSize: 22,
              ),
              text: '|',
            ),
            TextSpan(
              style: context.appTextStyles.subtitle2BOld,
              text: title,
            ),
          ],
        ),
      ),
    );
  }
}
