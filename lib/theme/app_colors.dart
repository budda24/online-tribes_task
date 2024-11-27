// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppColors {
  final Color primaryColor;
  final Color secondaryColor;
  final Color primaryColorLight;
  final Color accentColor;
  final Color backgroundColor;
  final Color scaffoldBackgroundColor;
  final Color canvasColor;
  final Color cardColor;
  final Color dividerColor;
  final Color buttonColor;
  final Color disabledColor;
  final Color splashColor;
  final Color highlightColor;
  final Color hoverColor;
  final Color focusColor;
  final Color errorColor;
  final Color redColor;
  final Color textColor;
  final Color shadowColor;
  final Color shimmerBaseColor;
  final Color shimmerHighlightColor;
  final Color successColor;
  final Color dropdownListColor;
  final Color dropdownDividerColor;
  final List<Color> gradientBackground;

  AppColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.primaryColorLight,
    required this.accentColor,
    required this.backgroundColor,
    required this.scaffoldBackgroundColor,
    required this.canvasColor,
    required this.cardColor,
    required this.dividerColor,
    required this.buttonColor,
    required this.disabledColor,
    required this.splashColor,
    required this.highlightColor,
    required this.hoverColor,
    required this.focusColor,
    required this.errorColor,
    required this.redColor,
    required this.textColor,
    required this.shadowColor,
    required this.shimmerBaseColor,
    required this.shimmerHighlightColor,
    required this.gradientBackground,
    required this.successColor,
    required this.dropdownListColor,
    required this.dropdownDividerColor,
  });

  factory AppColors.defaultColors() {
    return AppColors(
      gradientBackground: <Color>[
        const Color(0xff9b84ef),
        const Color(0xff8366EB),
      ],
      primaryColor: const Color(0xFF8366EB),
      primaryColorLight: const Color(0xFF8366EB),
      accentColor: const Color(0xFFFFDB4E),
      backgroundColor: const Color(0xFFFDFDFD),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      canvasColor: const Color(0xFFFFFFFF),
      cardColor: const Color(0xFFFFFFFF),
      dividerColor: const Color(0xFFf1f1f1),
      buttonColor: const Color(0xFF816DCD),
      disabledColor: const Color(0xFFA8A8A8),
      dropdownListColor: const Color(0xFFF5F5F5),
      dropdownDividerColor: const Color(0xFFD0D0D0),
      splashColor: Colors.transparent, // Placeholder, update as needed
      highlightColor: Colors.transparent, // Placeholder, update as needed
      hoverColor: Colors.transparent, // Placeholder, update as needed
      focusColor: Colors.transparent, // Placeholder, update as needed
      errorColor: const Color(0xFFEB6666),
      redColor: Colors.red,
      secondaryColor: const Color(0xFFf1f1f1),
      textColor: const Color(0xFF2B2B2B),
      shadowColor: const Color(0xFF000000),
      shimmerBaseColor: Colors.blueGrey[100]!,
      shimmerHighlightColor: Colors.blueGrey[50]!,
      successColor: const Color(0xFF13BB45),
    );
  }
}
