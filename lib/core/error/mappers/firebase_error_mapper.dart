import 'package:firebase_core/firebase_core.dart';
import 'package:online_tribes/core/error/reasons/firebase_error_reason.dart';

class FirebaseErrorReasonMapper {
  /// Maps Firebase exception codes to FirebaseErrorReason enum values.
  static FirebaseErrorReason mapFirebaseError(FirebaseException exception) {
    switch (exception.plugin) {
      case 'firebase_storage':
        return _mapFirebaseStorageError(exception.code);
      case 'cloud_firestore':
        return _mapFirestoreError(exception.code);
      default:
        return FirebaseErrorReason.unknownError;
    }
  }

  static FirebaseErrorReason _mapFirebaseStorageError(String errorCode) {
    switch (errorCode) {
      case 'object-not-found':
        return FirebaseErrorReason.objectNotFound;
      case 'bucket-not-found':
        return FirebaseErrorReason.bucketNotFound;
      case 'project-not-found':
        return FirebaseErrorReason.projectNotFound;
      case 'quota-exceeded':
        return FirebaseErrorReason.quotaExceeded;
      case 'unauthenticated':
        return FirebaseErrorReason.unauthenticated;
      case 'unauthorized':
        return FirebaseErrorReason.unauthorized;
      case 'retry-limit-exceeded':
        return FirebaseErrorReason.retryLimitExceeded;
      case 'invalid-checksum':
        return FirebaseErrorReason.invalidChecksum;
      case 'canceled':
        return FirebaseErrorReason.canceled;
      case 'invalid-event-name':
        return FirebaseErrorReason.invalidEventName;
      case 'invalid-url':
        return FirebaseErrorReason.invalidUrl;
      case 'invalid-argument':
        return FirebaseErrorReason.invalidArgument;
      default:
        return FirebaseErrorReason.unknownError;
    }
  }

  static FirebaseErrorReason _mapFirestoreError(String errorCode) {
    switch (errorCode) {
      case 'not-found':
        return FirebaseErrorReason.notFound;
      case 'permission-denied':
        return FirebaseErrorReason.permissionDenied;
      case 'resource-exhausted':
        return FirebaseErrorReason.resourceExhausted;
      case 'cancelled':
        return FirebaseErrorReason.firestoreCancelled;
      case 'invalid-argument':
        return FirebaseErrorReason.invalidArgument;
      case 'deadline-exceeded':
        return FirebaseErrorReason.deadlineExceeded;
      case 'already-exists':
        return FirebaseErrorReason.alreadyExists;
      case 'internal':
        return FirebaseErrorReason.internalError;
      case 'unavailable':
        return FirebaseErrorReason.unavailable;
      case 'data-loss':
        return FirebaseErrorReason.dataLoss;
      default:
        return FirebaseErrorReason.unknownError;
    }
  }
}
