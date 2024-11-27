import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<Either<BaseApiError<dynamic>, UserCredential>> call() async {
    return repository.signInWithGoogle();
  }
}
