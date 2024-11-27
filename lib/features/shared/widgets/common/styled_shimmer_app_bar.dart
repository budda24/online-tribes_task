import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class StyledShimmerAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const StyledShimmerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Shimmer.fromColors(
        baseColor: context.appColors.shimmerBaseColor,
        highlightColor: context.appColors.shimmerHighlightColor,
        child: Container(
          width: 150.h,
          height: 20.w,
          color: Colors.grey[300],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
