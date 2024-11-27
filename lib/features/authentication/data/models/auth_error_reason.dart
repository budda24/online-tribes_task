import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

enum AuthErrorReason {
  emailAlreadyExists,
  userNotFound,
  invalidEmail,
  wrongPassword,
  userDisabled,
  tooManyRequests,
  operationNotAllowed,
  unknownError,
  emailAlreadyVerified,
  emailNotVerified,
  unauthenticatedUser,
}

extension AuthErrorReasonMessageExtension on AuthErrorReason {
  String localizedMessage(BuildContext context) {
    final localizations = context.localizations;

    switch (this) {
      case AuthErrorReason.emailAlreadyExists:
        return localizations.emailAlreadyExistsError;
      case AuthErrorReason.userNotFound:
        return localizations.userNotFoundError;
      case AuthErrorReason.invalidEmail:
        return localizations.invalidEmailError;
      case AuthErrorReason.wrongPassword:
        return localizations.wrongPasswordError;
      case AuthErrorReason.userDisabled:
        return localizations.userDisabledError;
      case AuthErrorReason.tooManyRequests:
        return localizations.tooManyRequestsError;
      case AuthErrorReason.operationNotAllowed:
        return localizations.operationNotAllowedError;
      case AuthErrorReason.emailAlreadyVerified:
        return localizations.emailAlreadyVerifiedError;
      case AuthErrorReason.emailNotVerified:
        return localizations.emailNotVerified;
      case AuthErrorReason.unknownError:
        return localizations.unknownError;
      case AuthErrorReason.unauthenticatedUser:
        return localizations.unauthenticatedUser;
    }
  }
}
