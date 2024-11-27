import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledOutlineButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const StyledOutlineButton({
    required this.onPressed,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 14.h,
          ),
          elevation: 10,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
