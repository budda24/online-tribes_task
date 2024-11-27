import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';

class IsTribeNameTakenUseCase {
  final TribeRepository repository;

  IsTribeNameTakenUseCase(this.repository);

  Future<Either<BaseApiError, bool>> call({required String tribeName}) {
    return repository.isTribeNameTaken(tribeName);
  }
}
