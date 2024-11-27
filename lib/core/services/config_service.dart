import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/firebase_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/platform_error_reason.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/models/tribe_general_rules_model.dart';

class ConfigService {
  final FirebaseFirestore _firestore;
  final LoggerService _logger;

  ConfigService(
    this._firestore,
    this._logger,
  );

  TribeGeneralRulesModel? _tribeGeneralRules;

  Future<Either<BaseApiError, TribeGeneralRulesModel>>
      fetchTribeGeneralRules() async {
    if (_tribeGeneralRules != null) {
      _logger.logInfo(message: 'Returning cached general tribe rules');
      return Right(_tribeGeneralRules!);
    }

    try {
      final docSnapshot = await _firestore
          .collection(FirestoreCollections.config)
          .doc(FirestoreCollections.tribeRulesConfig)
          .get();

      _tribeGeneralRules = TribeGeneralRulesModel.fromJson(docSnapshot.data()!);
      _logger.logInfo(message: 'Fetched tribe general rules from Firestore');
      return Right(_tribeGeneralRules!);
    } on FirebaseException catch (e, stackTrace) {
      _logger.logError(
        message: 'Error fetching tribe general rules from Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
        ),
      );
    } catch (e, stackTrace) {
      _logger.logError(
        message: 'Unknown error fetching general tribe rules from Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return const Left(
        BaseApiError<PlatformErrorReason>(
          reason: PlatformErrorReason.unknownError,
        ),
      );
    }
  }
}
