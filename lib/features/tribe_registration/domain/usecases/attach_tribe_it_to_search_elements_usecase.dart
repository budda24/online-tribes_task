import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';

class AttachTribeToSearchElementsUseCase {
  final TribeRepository tribeRepository;

  AttachTribeToSearchElementsUseCase(this.tribeRepository);

  Future<Either<BaseApiError<dynamic>, void>> call({
    required TribeModel tribeModel,
    required String userName,
    required WriteBatch batch,
  }) {
    return tribeRepository.attachTribeToSearchElements(
      tribeModel,
      userName,
      batch,
    );
  }
}
