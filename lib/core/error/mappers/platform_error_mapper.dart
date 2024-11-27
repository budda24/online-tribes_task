import 'package:flutter/services.dart';
import 'package:online_tribes/core/error/reasons/platform_error_reason.dart';

class PlatformErrorMapper {
  /// Maps PlatformException to PlatformErrorReason enum values.
  static PlatformErrorReason mapPlatformErrorToPlatformErrorReason(
    PlatformException exception,
  ) {
    switch (exception.code) {
      // Firebase Auth related errors
      case 'ERROR_INVALID_EMAIL':
      case 'auth/invalid-email':
        return PlatformErrorReason.invalidEmail;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
      case 'auth/email-already-in-use':
        return PlatformErrorReason.emailAlreadyExists;
      case 'ERROR_USER_NOT_FOUND':
      case 'auth/user-not-found':
        return PlatformErrorReason.userNotFound;
      case 'ERROR_WRONG_PASSWORD':
      case 'auth/wrong-password':
        return PlatformErrorReason.wrongPassword;
      case 'ERROR_USER_DISABLED':
      case 'auth/user-disabled':
        return PlatformErrorReason.userDisabled;
      case 'ERROR_TOO_MANY_REQUESTS':
      case 'auth/too-many-requests':
        return PlatformErrorReason.tooManyRequests;
      case 'ERROR_OPERATION_NOT_ALLOWED':
      case 'auth/operation-not-allowed':
        return PlatformErrorReason.operationNotAllowed;

      // Google Sign-In related errors
      case 'sign_in_failed':
        return PlatformErrorReason.signInFailed;
      case 'network_error':
        return PlatformErrorReason.networkError;
      case 'play_store_not_found':
        return PlatformErrorReason.playStoreNotFound;

      // In-app purchase related errors
      case 'billing_unavailable':
        return PlatformErrorReason.billingUnavailable;
      case 'item_unavailable':
        return PlatformErrorReason.itemUnavailable;
      case 'developer_error':
        return PlatformErrorReason.developerError;
      case 'service_unavailable':
        return PlatformErrorReason.serviceUnavailable;
      case 'user_canceled':
        return PlatformErrorReason.userCanceled;
      case 'payment_error':
        return PlatformErrorReason.paymentError;

      // General errors
      case 'timeout':
        return PlatformErrorReason.timeout;
      case 'cancelled':
        return PlatformErrorReason.cancelled;
      case 'unavailable':
        return PlatformErrorReason.unavailable;

      // Default fallback
      default:
        return PlatformErrorReason.unknownError;
    }
  }
}
