import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class TextFieldLogin extends StatelessWidget {
  const TextFieldLogin({required this.hintText, super.key});
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.50,
      child: Container(
        width: 335.w,
        height: 64.h,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x7F00B74A),
              blurRadius: 1,
              offset: Offset(0, 3),
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: context.appColors.backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: context.appColors.primaryColor),
              borderRadius: BorderRadius.circular(5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFF00B84A),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            hintText: hintText,
            hintStyle: context.appTextStyles.headline1,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
          ),
        ),
      ),
    );
  }
}
