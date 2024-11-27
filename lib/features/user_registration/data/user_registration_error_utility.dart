import 'package:flutter/material.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/features/user_registration/data/models/user_registration_error_reason.dart';

class RegistrationErrorUtility {
  static String getAuthErrorMessage(
    BuildContext context,
    BaseApiError<dynamic>? error,
  ) {
    if (error != null && error.reason is UserRegistrationErrorReason) {
      final reason = error.reason as UserRegistrationErrorReason;
      return reason.localizedMessage(context);
    }
    return ErrorUtility.getErrorMessage(context, error);
  }
}
