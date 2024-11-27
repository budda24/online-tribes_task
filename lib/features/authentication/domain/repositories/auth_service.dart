import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<firebase_auth.UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<firebase_auth.UserCredential> signInWithCredential(
    OAuthCredential credential,
  );
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);

  Future<void> resendVerificationEmail();
  User? get user;
}

class FirebaseAuthService implements IAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  @override
  Future<firebase_auth.UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<firebase_auth.UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> resendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw Exception('User not logged in or email already verified');
    }
  }

  @override
  firebase_auth.User? get user => _firebaseAuth.currentUser;

  @override
  Future<firebase_auth.UserCredential> signInWithCredential(
    firebase_auth.OAuthCredential credential,
  ) async {
    return _firebaseAuth.signInWithCredential(credential);
  }
}
