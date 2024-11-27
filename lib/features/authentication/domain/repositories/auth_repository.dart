import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_tribes/core/error/base_api_error.dart';

abstract class AuthRepository {
  Future<Either<BaseApiError<dynamic>, void>> signOut();

  Future<Either<BaseApiError<dynamic>, UserCredential>> signInWithGoogle();
  User? get user;
}
