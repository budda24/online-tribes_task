import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_error_reason.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';

class CreateTribeUseCase {
  final TribeRepository repository;

  CreateTribeUseCase(this.repository);

  Future<Either<BaseApiError<dynamic>, void>> call(
    TribeModel tribeModel,
    String
        tribeId, // This parameter might be redundant if tribeId is part of tribeModel
  ) async {
    // Check if tribe name is taken
    final isTakenResult = await repository.isTribeNameTaken(tribeModel.name);

    return await isTakenResult.fold(
      // If an error occurred while checking the tribe name
      Left.new,
      (isTaken) async {
        if (isTaken) {
          // Tribe name is already taken
          return const Left(
            BaseApiError<TribeErrorReason>(
              reason: TribeErrorReason.tribeNameExist,
            ),
          );
        } else {
          // Tribe name is available, proceed to save the tribe
          final saveResult = await repository.saveTribe(tribeModel);

          return saveResult.fold(
            // If an error occurred while saving the tribe
            Left.new,
            (_) => const Right(null), // Tribe saved successfully
          );
        }
      },
    );
  }
}
