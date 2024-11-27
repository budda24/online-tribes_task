// ignore_for_file: eol_at_end_of_file

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/models/google_auth_service_user.dart';

class GoogleAuthService {
  late final GoogleSignIn _client;

  GoogleAuthService() {
    _client = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/userinfo.email',
      ],
    );

    _disconnectExistingSession();
  }

  Future<void> _disconnectExistingSession() async {
    try {
      // In case if we already signed in with Google, our account will be remembered and sign in popup will not appear on the screen
      // so if we need to switch to different account it will not be possible.
      // To fix this, we can disconnect it so then every time when user try to sign in,
      // popup screen will get displayed and user can choose account. As it might throw an error (in case if we are not signed in)
      // I wrapped it in try/catch block
      await _client.disconnect();
    } catch (_) {}
  }

  Future<Either<BaseApiError, GoogleAuthServiceUser>> signIn() async {
    final response = await _client.signIn();

    if (response == null) {
      return Left(GoogleAuthServiceError.cancelledByUser());
    } else {
      try {
        final googleAuth = await response.authentication;

        return Right(
          GoogleAuthServiceUser(
            email: response.email,
            authCredential: GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          ),
        );
      } catch (_) {
        return Left(GoogleAuthServiceError.unknownError());
      }
    }
  }
}

class GoogleAuthServiceError extends BaseApiError {
  const GoogleAuthServiceError({
    required super.reason,
  });

  factory GoogleAuthServiceError.cancelledByUser() {
    return const GoogleAuthServiceError(reason: 'CANCELLED_BY_USER');
  }

  factory GoogleAuthServiceError.unknownError() {
    return const GoogleAuthServiceError(reason: 'UNKNOWN_ERROR');
  }
}
