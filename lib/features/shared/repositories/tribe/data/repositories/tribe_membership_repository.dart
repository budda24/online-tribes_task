import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/firebase_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/platform_error_reason.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/features/shared/models/user_info.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/enum/tribe_membership_ticket_status.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/enum/tribe_membership_ticket_type.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_membership_ticket.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';

abstract class TribeMembershipRepository {
  Future<Either<BaseApiError<dynamic>, void>> sendJoinRequest(
    TribeMembershipTicket joinRequest,
  );

  Future<Either<BaseApiError<dynamic>, void>> sendInvitation(
    TribeMembershipTicket invitation,
  );

  Future<Either<BaseApiError<dynamic>, List<TribeMembershipTicket>>>
      findPendingTribeJoinRequests(
    String tribeId,
  );

  Future<Either<BaseApiError<dynamic>, List<TribeMembershipTicket>>>
      findPendingTribeJoinRequestsForUser({
    required String tribeId,
    required String userId,
  });

  Future<Either<BaseApiError<dynamic>, void>> acceptJoinRequest({
    required String ticketId,
    required String tribeId,
    required UserInfo userInfo,
  });

  Future<Either<BaseApiError<dynamic>, void>> denyJoinRequest(
    String ticketId,
  );
}

class TribeMembershipRepositoryImpl implements TribeMembershipRepository {
  final FirebaseFirestore firestore;
  final LoggerService logger;

  TribeMembershipRepositoryImpl({
    required this.firestore,
    required this.logger,
  });

  @override
  Future<Either<BaseApiError, void>> sendInvitation(
    TribeMembershipTicket invitation,
  ) {
    // TODO(Mateusz): to be implemented in next PR
    throw UnimplementedError();
  }

  @override
  Future<Either<BaseApiError, void>> sendJoinRequest(
    TribeMembershipTicket joinRequest,
  ) async {
    try {
      final tribeRequestsCollectionRef =
          firestore.collection(FirestoreCollections.tribeMembershipTickets);

      await tribeRequestsCollectionRef.add(joinRequest.toJson());

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(
        _handleFirebaseException(
          e,
          stackTrace,
          message: 'Error sending tribe join request data to Firestore',
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        _handleGeneralException(
          error,
          stackTrace,
          message: 'Error sending tribe join request data to Firestore',
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError, List<TribeMembershipTicket>>>
      findPendingTribeJoinRequests(
    String tribeId,
  ) async {
    try {
      final tribeRequestsCollectionRef =
          firestore.collection(FirestoreCollections.tribeMembershipTickets);

      final querySnap = await tribeRequestsCollectionRef
          .where('tribeInfo.id', isEqualTo: tribeId)
          .where('type', isEqualTo: TribeMembershipTicketType.joinRequest.value)
          .where('status', isEqualTo: TribeMembershipTicketStatus.pending.value)
          .get();

      final tribeRequestTickets =
          querySnap.docs.map(TribeMembershipTicket.fromDoc).toList();

      return Right(tribeRequestTickets);
    } on FirebaseException catch (e, stackTrace) {
      return Left(
        _handleFirebaseException(
          e,
          stackTrace,
          message: 'Error fetching tribe join requests data from Firestore',
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        _handleGeneralException(
          error,
          stackTrace,
          message: 'Error fetching tribe join request data from Firestore',
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError, List<TribeMembershipTicket>>>
      findPendingTribeJoinRequestsForUser({
    required String tribeId,
    required String userId,
  }) async {
    try {
      final tribeRequestsCollectionRef =
          firestore.collection(FirestoreCollections.tribeMembershipTickets);

      final querySnap = await tribeRequestsCollectionRef
          .where('tribeInfo.id', isEqualTo: tribeId)
          .where('senderInfo.id', isEqualTo: userId)
          .where('type', isEqualTo: TribeMembershipTicketType.joinRequest.value)
          .where('status', isEqualTo: TribeMembershipTicketStatus.pending.value)
          .get();

      final tribeRequestTickets =
          querySnap.docs.map(TribeMembershipTicket.fromDoc).toList();

      return Right(tribeRequestTickets);
    } on FirebaseException catch (e, stackTrace) {
      return Left(
        _handleFirebaseException(
          e,
          stackTrace,
          message: 'Error fetching tribe join requests data from Firestore',
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        _handleGeneralException(
          error,
          stackTrace,
          message: 'Error fetching tribe join request data from Firestore',
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError, void>> acceptJoinRequest({
    required String ticketId,
    required String tribeId,
    required UserInfo userInfo,
  }) async {
    final addMemberResponse = await _addMemberToTribe(
      tribeId: tribeId,
      userInfo: userInfo,
    );

    if (addMemberResponse.isLeft()) {
      return addMemberResponse;
    }

    try {
      // Update the status of the join request ticket
      final tribeRequestsCollectionRef =
          firestore.collection(FirestoreCollections.tribeMembershipTickets);

      await tribeRequestsCollectionRef.doc(ticketId).update(
        {
          'status': TribeMembershipTicketStatus.accepted.value,
        },
      );

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(
        _handleFirebaseException(
          e,
          stackTrace,
          message: 'Error on accept join request in Firestore',
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        _handleGeneralException(
          error,
          stackTrace,
          message: 'Error on accept join request in Firestore',
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError, void>> denyJoinRequest(String ticketId) async {
    try {
      final tribeRequestsCollectionRef =
          firestore.collection(FirestoreCollections.tribeMembershipTickets);

      await tribeRequestsCollectionRef.doc(ticketId).update(
        {
          'status': TribeMembershipTicketStatus.denied.value,
        },
      );

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(
        _handleFirebaseException(
          e,
          stackTrace,
          message: 'Error on deny join request in Firestore',
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        _handleGeneralException(
          error,
          stackTrace,
          message: 'Error on deny join request in Firestore',
        ),
      );
    }
  }

  Future<Either<BaseApiError, void>> _addMemberToTribe({
    required String tribeId,
    required UserInfo userInfo,
  }) async {
    try {
      final tribesCollectionRef =
          firestore.collection(FirestoreCollections.tribes);

      await tribesCollectionRef.doc(tribeId).update(
        {
          TribeModel.fieldMembers: FieldValue.arrayUnion([userInfo.toJson()]),
        },
      );

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      return Left(
        _handleFirebaseException(
          e,
          stackTrace,
          message: 'Error on adding user to Tribe members in Firestore',
        ),
      );
    } catch (error, stackTrace) {
      return Left(
        _handleGeneralException(
          error,
          stackTrace,
          message: 'Error on adding user  to Tribe members in Firestore',
        ),
      );
    }
  }

  BaseApiError<dynamic> _handleFirebaseException(
    FirebaseException e,
    StackTrace stackTrace, {
    required String message,
  }) {
    logger.logError(
      message: message,
      error: e,
      stackTrace: stackTrace,
    );
    return BaseApiError(
      reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
    );
  }

  BaseApiError<dynamic> _handleGeneralException(
    Object error,
    StackTrace stackTrace, {
    required String message,
  }) {
    logger.logError(
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
    return const BaseApiError<PlatformErrorReason>(
      reason: PlatformErrorReason.unknownError,
    );
  }
}
