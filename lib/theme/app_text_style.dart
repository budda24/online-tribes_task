// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/injection.dart';
import 'package:online_tribes/theme/app_colors.dart';

class AppTextStyles {
  final String fontFamily;
  final TextStyle headline1;
  final TextStyle headline2;
  final TextStyle headline3;
  final TextStyle headline4;
  final TextStyle headline4Bold;
  final TextStyle subtitle1;
  final TextStyle subtitle2;
  final TextStyle subtitle2BOld;
  final TextStyle bodyText1;
  final TextStyle bodyText2;
  final TextStyle button;
  final TextStyle overline;

  AppTextStyles({
    required this.fontFamily,
    required this.headline1,
    required this.headline2,
    required this.headline3,
    required this.headline4,
    required this.headline4Bold,
    required this.subtitle1,
    required this.subtitle2,
    required this.subtitle2BOld,
    required this.bodyText1,
    required this.bodyText2,
    required this.button,
    required this.overline,
  });

  factory AppTextStyles.defaultStyles() {
    final textColor = getIt<AppColors>().textColor;
    return AppTextStyles(
      fontFamily: 'Poppins',
      headline1: TextStyle(
        fontSize: 32.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w800,
      ),
      headline2: TextStyle(
        fontSize: 28.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      headline3: TextStyle(
        fontSize: 24.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      headline4: TextStyle(
        fontSize: 20.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headline4Bold: TextStyle(
        fontSize: 20.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w900,
      ),
      subtitle1: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      subtitle2: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w400,
      ),
      subtitle2BOld: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      bodyText2: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w300,
      ),
      button: TextStyle(
        fontSize: 16.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      overline: TextStyle(
        fontSize: 10.sp,
        fontFamily: 'Poppins',
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
