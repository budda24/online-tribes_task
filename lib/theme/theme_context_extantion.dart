import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Easy access to specific colors
  Color get primaryColor => theme.primaryColor;
  Color get accentColor => theme.colorScheme.secondary;
  Color get backgroundColor => theme.colorScheme.surface;
  Color get errorColor => theme.colorScheme.error;

  // Easy access to specific text styles
  TextStyle get headline1 => textTheme.displayLarge!;
  TextStyle get headline2 => textTheme.displayMedium!;
  TextStyle get headline3 => textTheme.displaySmall!;
  TextStyle get headline4 => textTheme.headlineMedium!;
  TextStyle get bodyText1 => textTheme.bodyLarge!;
  TextStyle get caption => textTheme.bodySmall!;
  TextStyle get button => textTheme.labelLarge!;
}
