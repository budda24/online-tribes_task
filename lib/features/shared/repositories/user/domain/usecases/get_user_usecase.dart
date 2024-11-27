import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';

/// Use case for retrieving a user from Firestore by userId
class GetUserUseCase {
  final UserRepository userRepository;

  GetUserUseCase({
    required this.userRepository,
  });

  /// Executes the use case to get a user by userId
  Future<Either<BaseApiError<dynamic>, UserModel>> call(String userId) async {
    return userRepository.getUser(userId);
  }
}
