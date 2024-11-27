import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<BaseApiError<dynamic>, void>> call() async {
    return repository.signOut();
  }
}
