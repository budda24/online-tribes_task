import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

enum FirebaseErrorReason {
  // Firebase Storage error reasons
  objectNotFound,
  bucketNotFound,
  projectNotFound,
  quotaExceeded,
  unauthenticated,
  unauthorized,
  retryLimitExceeded,
  invalidChecksum,
  canceled,
  invalidEventName,
  invalidUrl,
  invalidArgument,

  // Firestore error reasons
  notFound,
  permissionDenied,
  resourceExhausted,
  firestoreCancelled,
  deadlineExceeded,
  alreadyExists,
  internalError,
  unavailable,
  dataLoss,

  // General unknown error reason
  unknownError,
}

extension FirebaseErrorReasonMessageExtension on FirebaseErrorReason {
  String localizedMessage(BuildContext context) {
    final localizations = context.localizations;
    switch (this) {
      // Firebase Storage related errors
      case FirebaseErrorReason.objectNotFound:
        return localizations.notFoundError;
      case FirebaseErrorReason.bucketNotFound:
        return localizations.notFoundError;
      case FirebaseErrorReason.projectNotFound:
        return localizations.notFoundError;
      case FirebaseErrorReason.quotaExceeded:
        return localizations.resourceExhaustedError;
      case FirebaseErrorReason.unauthenticated:
        return localizations.unauthorizedError;
      case FirebaseErrorReason.unauthorized:
        return localizations.unauthorizedError;
      case FirebaseErrorReason.retryLimitExceeded:
        return localizations.tooManyRequestsError;
      case FirebaseErrorReason.invalidChecksum:
        return localizations.genericErrorMessage;
      case FirebaseErrorReason.canceled:
        return localizations.cancelledError;
      case FirebaseErrorReason.invalidEventName:
        return localizations.invalidArgumentError;
      case FirebaseErrorReason.invalidUrl:
        return localizations
            .invalidUrlError; // Add this key to your localization file if needed.
      case FirebaseErrorReason.invalidArgument:
        return localizations.invalidArgumentError;

      // Firestore related errors
      case FirebaseErrorReason.notFound:
        return localizations.notFoundError;
      case FirebaseErrorReason.permissionDenied:
        return localizations.permissionDeniedError;
      case FirebaseErrorReason.resourceExhausted:
        return localizations.resourceExhaustedError;
      case FirebaseErrorReason.firestoreCancelled:
        return localizations.cancelledError;
      case FirebaseErrorReason.deadlineExceeded:
        return localizations.deadlineExceededError;
      case FirebaseErrorReason.alreadyExists:
        return localizations.alreadyExistsError;
      case FirebaseErrorReason.internalError:
        return localizations.internalError;
      case FirebaseErrorReason.unavailable:
        return localizations.unavailableError;
      case FirebaseErrorReason.dataLoss:
        return localizations.dataLossError;

      case FirebaseErrorReason.unknownError:
        return localizations.unknownError;
    }
  }
}
