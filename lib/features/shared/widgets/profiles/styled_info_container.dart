import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledInformationContainer extends StatelessWidget {
  final String text;

  const StyledInformationContainer({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: context.appColors.secondaryColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [context.appWidgetStyles.dropShadow],
        ),
        child: Text(
          text, // Use user bio
          textAlign: TextAlign.center,
          style: context.appTextStyles.bodyText1,
        ),
      ),
    );
  }
}
