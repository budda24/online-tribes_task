import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

enum PlatformErrorReason {
  // Firebase Auth related errors
  invalidEmail,
  emailAlreadyExists,
  userNotFound,
  wrongPassword,
  userDisabled,
  tooManyRequests,
  operationNotAllowed,

  // Google Sign-In related errors
  signInFailed,
  networkError,
  playStoreNotFound,

  // In-app purchase related errors
  billingUnavailable,
  itemUnavailable,
  developerError,
  serviceUnavailable,
  userCanceled,
  paymentError,

  // General errors
  timeout,
  cancelled,
  unavailable,

  // Unknown error
  unknownError,
}

extension PlatformErrorReasonMessageExtension on PlatformErrorReason {
  String localizedMessage(BuildContext context) {
    final localizations = context.localizations;

    switch (this) {
      // Firebase Auth related errors
      case PlatformErrorReason.invalidEmail:
        return localizations.invalidEmailError;
      case PlatformErrorReason.emailAlreadyExists:
        return localizations.emailAlreadyExistsError;
      case PlatformErrorReason.userNotFound:
        return localizations.userNotFoundError;
      case PlatformErrorReason.wrongPassword:
        return localizations.wrongPasswordError;
      case PlatformErrorReason.userDisabled:
        return localizations.userDisabledError;
      case PlatformErrorReason.tooManyRequests:
        return localizations.tooManyRequestsError;
      case PlatformErrorReason.operationNotAllowed:
        return localizations.operationNotAllowedError;

      // Google Sign-In related errors
      case PlatformErrorReason.signInFailed:
        return localizations.signInFailedError;
      case PlatformErrorReason.networkError:
        return localizations.networkError;
      case PlatformErrorReason.playStoreNotFound:
        return localizations.playStoreNotFoundError;

      // In-app purchase related errors
      case PlatformErrorReason.billingUnavailable:
        return localizations.billingUnavailableError;
      case PlatformErrorReason.itemUnavailable:
        return localizations.itemUnavailableError;
      case PlatformErrorReason.developerError:
        return localizations.developerError;
      case PlatformErrorReason.serviceUnavailable:
        return localizations.serviceUnavailableError;
      case PlatformErrorReason.userCanceled:
        return localizations.userCanceledError;
      case PlatformErrorReason.paymentError:
        return localizations.paymentError;

      // General errors
      case PlatformErrorReason.timeout:
        return localizations
            .deadlineExceededError; // Reusing deadlineExceededError for timeout
      case PlatformErrorReason.cancelled:
        return localizations.cancelledError;
      case PlatformErrorReason.unavailable:
        return localizations.unavailableError;

      // Default fallback
      case PlatformErrorReason.unknownError:
        return localizations.unknownError;
    }
  }
}
