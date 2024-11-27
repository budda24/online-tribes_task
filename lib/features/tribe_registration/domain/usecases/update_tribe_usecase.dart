import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';

class UpdateTribeUseCase {
  final TribeRepository tribeRepository;

  UpdateTribeUseCase(this.tribeRepository);

  Future<Either<BaseApiError<dynamic>, void>> call({
    required String tribeId,
    required Map<String, dynamic> tribeData,
    WriteBatch? batch,
  }) {
    return tribeRepository.updateTribe(
      tribeId,
      tribeData,
      batch,
    );
  }
}
