import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuthServiceUser {
  final String email;
  final OAuthCredential authCredential;

  GoogleAuthServiceUser({
    required this.email,
    required this.authCredential,
  });
}
