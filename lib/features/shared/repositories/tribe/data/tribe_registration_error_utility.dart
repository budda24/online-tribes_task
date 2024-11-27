import 'package:flutter/material.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_error_reason.dart';

class TribeRegistrationErrorUtility {
  static String getErrorMessage(
    BuildContext context,
    BaseApiError<dynamic>? error,
  ) {
    if (error != null && error.reason is TribeErrorReason) {
      final reason = error.reason as TribeErrorReason;
      return reason.localizedMessage(context);
    }
    return ErrorUtility.getErrorMessage(context, error);
  }
}
