import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';

/// Use case for saving a new user to Firestore
class SaveUserUseCase {
  final UserRepository userRepository;

  SaveUserUseCase({required this.userRepository});

  /// Executes the use case by saving the user in the repository
  Future<Either<BaseApiError<dynamic>, void>> call(UserModel userModel) async {
    return userRepository.saveUser(userModel);
  }
}
