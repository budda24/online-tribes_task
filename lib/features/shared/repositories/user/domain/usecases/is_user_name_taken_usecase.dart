import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';

class IsUserNameTakenUseCase {
  final UserRepository userRepository;

  IsUserNameTakenUseCase({required this.userRepository});

  Future<Either<BaseApiError<dynamic>, bool>> call({
    required String username,
  }) async {
    return userRepository.isUsernameTaken(
      username,
    );
  }
}
