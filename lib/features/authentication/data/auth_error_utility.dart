import 'package:flutter/material.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/features/authentication/data/models/auth_error_reason.dart';

class AuthErrorUtility {
  static String getAuthErrorMessage(
    BuildContext context,
    BaseApiError<dynamic>? error,
  ) {
    if (error != null && error.reason.runtimeType == AuthErrorReason) {
      final reason = error.reason as AuthErrorReason;
      return reason.localizedMessage(context);
    }
    return ErrorUtility.getErrorMessage(context, error);
  }
}
