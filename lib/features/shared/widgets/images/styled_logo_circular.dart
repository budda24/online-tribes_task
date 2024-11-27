import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/gen/assets.gen.dart';

class StyledLogoCircular extends StatelessWidget {
  final double size;
  const StyledLogoCircular({
    required this.size, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Assets.shared.logo.logoSquer.image(
        width: size.w,
        height: size.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
