import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final IconData? leadingIcon;
  final double borderRadius;

  StyledFilledButton({
    required this.onPressed,
    required this.buttonText,
    this.leadingIcon,
    super.key,
  }) : borderRadius = 30.r;

  StyledFilledButton.disabled({
    required this.buttonText,
    this.leadingIcon,
    super.key,
  })  : onPressed = null,
        borderRadius = 30.r;

  StyledFilledButton.sharp({
    required this.onPressed,
    required this.buttonText,
    this.leadingIcon,
    super.key,
  }) : borderRadius = 5.r;

  StyledFilledButton.disabledSharp({
    required this.buttonText,
    this.leadingIcon,
    super.key,
  })  : onPressed = null,
        borderRadius = 5.r;

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return _buildDisabledButton(context);
    } else {
      return _buildEnabledButton(context);
    }
  }

  Widget _buildEnabledButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: context.appColors.gradientBackground,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 14.h,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon,
                  size: 20.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisabledButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(
            color: context.appColors.disabledColor,
          ),
          padding: EdgeInsets.symmetric(
            vertical: 14.h,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 20.sp,
                color: context.appColors.disabledColor,
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 18.sp,
                color: context.appColors.disabledColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
