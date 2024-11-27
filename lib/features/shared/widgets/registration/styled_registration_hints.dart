import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledRegistrationHints extends StatelessWidget {
  final List<String> hints;

  const StyledRegistrationHints({required this.hints, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(hints.length, (index) {
          return Column(
            children: [
              Text(
                '${index + 1}. ${hints[index]}',
                style: context.appTextStyles.bodyText1,
                textAlign: TextAlign.center,
              ),
              5.verticalSpace,
            ],
          );
        }),
      ),
    );
  }
}
