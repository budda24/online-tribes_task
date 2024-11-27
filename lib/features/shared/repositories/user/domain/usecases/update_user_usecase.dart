import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';

/// Params needed to update a user

/// Use case for updating user information in Firestore
class UpdateUserUseCase {
  final UserRepository userRepository;

  UpdateUserUseCase({required this.userRepository});

  /// Executes the use case by updating the user in the repository
  Future<Either<BaseApiError<dynamic>, void>> call({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    return userRepository.updateUser(userId, userData);
  }
}
