import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledLoadingIndicatorWidget extends StatelessWidget {
  final double strokeWidth;
  final bool showPathBackground;
  final bool pause;

  const StyledLoadingIndicatorWidget({
    super.key,
    this.strokeWidth = 4.0,
    this.showPathBackground = false,
    this.pause = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      width: 100.w,
      child: Center(
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          colors: [
            context.appColors.primaryColor,
            context.appColors.primaryColor,
            context.appColors.primaryColor,
            context.appColors.primaryColor,
            context.appColors.primaryColor,
            context.appColors.primaryColor,
            context.appColors.primaryColor,
          ],
          strokeWidth: strokeWidth,
          pathBackgroundColor: showPathBackground ? Colors.black45 : null,
          pause: pause,
        ),
      ),
    );
  }
}
