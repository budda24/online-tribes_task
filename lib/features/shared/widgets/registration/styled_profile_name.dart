import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledProfileName extends StatelessWidget {
  final String name;
  const StyledProfileName({
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Text(
        name,
        style: context.appTextStyles.headline4
            .copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
