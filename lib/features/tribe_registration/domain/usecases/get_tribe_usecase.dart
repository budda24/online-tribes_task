import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';

class GetLastRegisteredTribeUseCase {
  final TribeRepository repository;

  GetLastRegisteredTribeUseCase(this.repository);

  Future<Either<BaseApiError, TribeModel>> call(String userId) async {
    final result = await repository.getLastRegisteredTribeByUserId(userId);
    return result.fold(
      Left.new,
      (tribe) {
        if (tribe == null) {
          return right<BaseApiError, TribeModel>(TribeModel.empty());
        } else {
          return right<BaseApiError, TribeModel>(tribe);
        }
      },
    );
  }
}
