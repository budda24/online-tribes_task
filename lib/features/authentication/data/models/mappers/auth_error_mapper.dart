import 'package:online_tribes/features/authentication/data/models/auth_error_reason.dart';

class AuthErrorMapper {
  /// Maps Firebase error codes to AuthErrorReason enum values.
  static AuthErrorReason mapFirebaseErrorToAuthError(String errorCode) {
    switch (errorCode) {
      case 'email-already-exists':
      case 'email-already-in-use':
        return AuthErrorReason.emailAlreadyExists;
      case 'user-not-found':
        return AuthErrorReason.userNotFound;
      case 'invalid-email':
        return AuthErrorReason.invalidEmail;
      case 'wrong-password':
        return AuthErrorReason.wrongPassword;
      case 'user-disabled':
        return AuthErrorReason.userDisabled;
      case 'too-many-requests':
        return AuthErrorReason.tooManyRequests;
      case 'operation-not-allowed':
        return AuthErrorReason.operationNotAllowed;
      default:
        return AuthErrorReason.unknownError;
    }
  }
}
