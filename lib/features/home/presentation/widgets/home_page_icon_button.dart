import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class HomePageIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const HomePageIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        icon,
        size: 30.r,
        color: context.appColors.textColor,
      ),
      onPressed: onPressed,
    );
  }
}
