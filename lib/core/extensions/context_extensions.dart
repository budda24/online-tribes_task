import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:online_tribes/core/di/injection.dart';
import 'package:online_tribes/core/models/supported_languages.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/theme/app_colors.dart';
import 'package:online_tribes/theme/app_text_style.dart';
import 'package:online_tribes/theme/app_widget_styles.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get localizations {
    return AppLocalizations.of(this)!;
  }

  Language get currantLanguage {
    switch (localizations.localeName) {
      case 'en':
        return Language.english;
      case 'pl':
        return Language.polish;
      case 'uk':
        return Language.ukrainian;
      default:
        throw Exception('Unsupported language'); // Handle unsupported locales
    }
  }
}

extension AppColorsExtension on BuildContext {
  AppColors get appColors => AppColors.defaultColors();
}

extension AppTextStylesExtension on BuildContext {
  AppTextStyles get appTextStyles => AppTextStyles.defaultStyles();
}

extension AppWidgetStylesExtension on BuildContext {
  AppWidgetStyles get appWidgetStyles => AppWidgetStyles();
}

extension BannerServiceExtension on BuildContext {
  void showErrorBanner(String message) =>
      getIt<BannerService>().showErrorBanner(context: this, message: message);
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  // Helper function to sanitize field names
  String sanitizeFieldName() {
    return replaceAll(RegExp(r'[./[\]#$]'), '');
  }
}

// AutoRouter extension
extension GoRouterExtension on BuildContext {
  /// Access the GoRouter directly
  GoRouter get router => GoRouter.of(this);

  /// Programmatically navigate to a new route
  void pushRoute(
    String location, {
    Map<String, String>? params,
    Map<String, dynamic>? extra,
  }) {
    GoRouter.of(this).push(location, extra: extra);
  }

  /// Replace the current route with a new one
  void replaceRoute(
    String location, {
    Map<String, String>? params,
    Map<String, dynamic>? extra,
  }) {
    GoRouter.of(this).go(location, extra: extra);
  }

  /// Navigate back to the previous route
  void popRoute() {
    GoRouter.of(this).pop();
  }

  /// Navigate to a named route (if using named routes)
  void pushNamedRoute(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) {
    GoRouter.of(this)
        .pushNamed(name, pathParameters: params ?? {}, extra: extra);
  }

  /// Replace the current route with a named route
  void replaceNamedRoute(
    String name, {
    Map<String, String>? params,
    Object? extra,
  }) {
    GoRouter.of(this).goNamed(name, pathParameters: params ?? {}, extra: extra);
  }
}
