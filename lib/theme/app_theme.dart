import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_tribes/theme/app_colors.dart';
import 'package:online_tribes/theme/app_text_style.dart';

class AppTheme {
  final AppColors colors;
  final AppTextStyles textStyles;

  AppTheme({
    required this.colors,
    required this.textStyles,
  });

  factory AppTheme.defaultTheme() {
    final colors = AppColors.defaultColors();
    final textStyles = AppTextStyles.defaultStyles();

    return AppTheme(
      colors: colors,
      textStyles: textStyles,
    );
  }

  ThemeData get themeData {
    return ThemeData(
      primaryColor: colors.primaryColor,
      primaryColorLight: colors.primaryColorLight,
      scaffoldBackgroundColor: colors.scaffoldBackgroundColor,
      canvasColor: colors.canvasColor,
      cardColor: colors.cardColor,
      dividerColor: colors.dividerColor,
      disabledColor: colors.disabledColor,
      splashColor: colors.splashColor,
      highlightColor: colors.highlightColor,
      hoverColor: colors.hoverColor,
      focusColor: colors.focusColor,
      textTheme: TextTheme(
        displayLarge: textStyles.headline1,
        displayMedium: textStyles.headline2,
        displaySmall: textStyles.headline3,
        headlineMedium: textStyles.headline4,
        titleMedium: textStyles.subtitle1,
        titleSmall: textStyles.subtitle2,
        bodyLarge: textStyles.bodyText1,
        bodyMedium: textStyles.bodyText2,
        labelLarge: textStyles.button,
        labelSmall: textStyles.overline,
      ),
      iconTheme: IconThemeData(
        color: colors.primaryColor,
        size: 16,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.backgroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
        elevation: 1,
        iconTheme: IconThemeData(
          size: 30,
          color: colors.primaryColor,
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: colors.backgroundColor,
        elevation: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.backgroundColor,
        selectedItemColor: colors.primaryColor,
        unselectedItemColor: colors.accentColor,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colors.buttonColor,
        disabledColor: colors.disabledColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.primaryColor,
        disabledColor: colors.disabledColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textStyles.subtitle1,
        helperStyle: textStyles.subtitle2,
        hintStyle: textStyles.bodyText2,
        errorStyle: TextStyle(color: colors.errorColor),
      ),
      colorScheme: ColorScheme(
        primary: colors.primaryColor,
        secondary: colors.accentColor,
        surface: colors.canvasColor,
        error: colors.errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        onError: Colors.white,
        brightness: Brightness.light,
      )
          .copyWith(secondary: colors.accentColor)
          .copyWith(surface: colors.backgroundColor)
          .copyWith(error: colors.errorColor),
    );
  }
}
