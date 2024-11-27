import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledMainPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? customPadding;

  // Default constructor
  const StyledMainPadding({
    required this.child,
    this.customPadding, // Allow custom padding
    super.key,
  });

  // Named constructor with small padding
  StyledMainPadding.small({
    required this.child,
    super.key,
  }) : customPadding = EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h);

  StyledMainPadding.dialog({
    required this.child,
    super.key,
  }) : customPadding = EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 32.h,
        );

  @override
  Widget build(BuildContext context) {
    // Default padding or custom padding
    final padding = customPadding ??
        EdgeInsets.symmetric(horizontal: 20.w).copyWith(
          top: 33.h,
          bottom: 64.w,
        );

    return Padding(
      padding: padding,
      child: child,
    );
  }
}
