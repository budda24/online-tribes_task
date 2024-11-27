import 'package:flutter/material.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/reasons/firebase_error_reason.dart';
import 'package:online_tribes/core/error/reasons/github_error_reason.dart';
import 'package:online_tribes/core/error/reasons/hive_error_reason.dart';
import 'package:online_tribes/core/error/reasons/platform_error_reason.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_error_reason.dart';

class ErrorUtility {
  static String getErrorMessage(
    BuildContext context,
    BaseApiError<dynamic>? error,
  ) {
    final appLocalizations = context.localizations;
    if (error == null) {
      return appLocalizations.genericErrorMessage;
    } else if (error.reason is PlatformErrorReason) {
      return (error.reason as PlatformErrorReason).localizedMessage(context);
    } else if (error.reason is FirebaseErrorReason) {
      return (error.reason as FirebaseErrorReason).localizedMessage(context);
    } else if (error.reason is UserErrorReason) {
      return (error.reason as UserErrorReason).localizedMessage(context);
    } else if (error.reason is HiveErrorReason) {
      return (error.reason as HiveErrorReason).localizedMessage(context);
    } else if (error.reason is GithubErrorReason) {
      return (error.reason as GithubErrorReason).localizedMessage(context);
    }
    return appLocalizations.genericErrorMessage;
  }
}
