import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/firebase_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/firebase_error_reason.dart';
import 'package:online_tribes/core/error/reasons/platform_error_reason.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_error_reason.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_tribes.dart';

abstract class TribeRepository {
  Future<Either<BaseApiError<dynamic>, void>> saveTribe(
    TribeModel tribeModel,
  );

  Future<Either<BaseApiError<dynamic>, TribeModel>> getTribe(String tribeId);

  Future<Either<BaseApiError<dynamic>, void>> updateTribe(
    String tribeId,
    Map<String, dynamic> tribeData, [
    WriteBatch? batch,
  ]);

  Future<Either<BaseApiError<dynamic>, bool>> isTribeNameTaken(
    String tribeName,
  );

  Future<Either<BaseApiError<dynamic>, void>> attachTribeToSearchElements(
    TribeModel tribeModel,
    String userName,
    WriteBatch batch,
  );

  Future<Either<BaseApiError<dynamic>, TribeModel?>>
      getLastRegisteredTribeByUserId(
    String userId,
  );

  Future<Either<BaseApiError<dynamic>, UserTribes>> getTribesForUser(
    String userId,
  );
}

class TribeRepositoryImpl implements TribeRepository {
  final FirebaseFirestore firestore;
  final LoggerService logger;

  TribeRepositoryImpl({
    required this.firestore,
    required this.logger,
  });

  @override
  Future<Either<BaseApiError<dynamic>, void>> saveTribe(
    TribeModel tribeModel,
  ) async {
    try {
      // Add the tribe document
      final tribeDocRef = firestore
          .collection(FirestoreCollections.tribes)
          .doc(tribeModel.tribeId);
      await tribeDocRef.set(tribeModel.toJson());

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error saving tribe data to Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
        ),
      );
    } catch (error, stackTrace) {
      logger.logError(
        message: 'Error saving tribe data to Firestore',
        error: error,
        stackTrace: stackTrace,
      );
      return const Left(
        BaseApiError<PlatformErrorReason>(
          reason: PlatformErrorReason.unknownError,
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError<dynamic>, TribeModel>> getTribe(
    String tribeId,
  ) async {
    try {
      final tribeDoc = await firestore
          .collection(FirestoreCollections.tribes)
          .doc(tribeId)
          .get();

      if (tribeDoc.exists) {
        final tribeModel = TribeModel.fromJson(tribeDoc.data()!);
        return Right(tribeModel);
      } else {
        return right(TribeModel.empty());
      }
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error fetching tribe data from Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
        ),
      );
    }
  }

  // Update the tribe without checking for tribe name uniqueness
  @override
  Future<Either<BaseApiError<dynamic>, void>> updateTribe(
    String tribeId,
    Map<String, dynamic> tribeData, [
    WriteBatch? batch,
  ]) async {
    try {
      final tribeDocRef =
          firestore.collection(FirestoreCollections.tribes).doc(tribeId);

      if (batch != null) {
        batch.update(tribeDocRef, tribeData);
      } else {
        await tribeDocRef.update(tribeData);
      }

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error updating tribe data in Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError<FirebaseErrorReason>(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
        ),
      );
    } catch (e) {
      return const Left(
        BaseApiError<FirebaseErrorReason>(
          reason: FirebaseErrorReason.unknownError,
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError<dynamic>, bool>> isTribeNameTaken(
    String tribeName,
  ) async {
    try {
      // Query the 'tribes' collection for documents where 'name' equals the provided tribe name
      final querySnapshot = await firestore
          .collection(FirestoreCollections.tribes)
          .where(TribeModel.fieldName, isEqualTo: tribeName)
          .limit(1) // Limit to 1 result for efficiency
          .get();

      final isTaken = querySnapshot.docs.isNotEmpty;

      return Right(isTaken);
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error checking tribe name in Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError<FirebaseErrorReason>(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
        ),
      );
    } catch (e, stackTrace) {
      logger.logError(
        message: 'Unknown error checking tribe name in Firestore',
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

  @override
  Future<Either<BaseApiError<dynamic>, void>> attachTribeToSearchElements(
    TribeModel tribeModel,
    String userName,
    WriteBatch batch,
  ) async {
    try {
      final typeaheadCollection =
          firestore.collection(FirestoreCollections.typeAhead);

      // 1. Update 'user-names' document
      final userNamesDocRef =
          typeaheadCollection.doc(FirestoreCollections.userNames);
      final userNameKey = userName.sanitizeFieldName();

      // Read existing data before the batch
      final userNamesSnapshot = await userNamesDocRef.get();
      var userNamesValues = <dynamic>[];
      if (userNamesSnapshot.exists &&
          userNamesSnapshot.data() != null &&
          userNamesSnapshot.data()!['values'] != null) {
        userNamesValues = List<dynamic>.from(
          userNamesSnapshot.data()!['values'] as List<dynamic>,
        );
      }

      // Modify the 'values' array
      var found = false;
      for (var i = 0; i < userNamesValues.length; i++) {
        final map = userNamesValues[i] as Map<String, dynamic>;
        if (map.containsKey(userNameKey)) {
          // Append the tribeId to the existing array
          final tribeIds =
              List<dynamic>.from(map[userNameKey] as List<dynamic>);
          if (!tribeIds.contains(tribeModel.tribeId)) {
            tribeIds.add(tribeModel.tribeId);
            map[userNameKey] = tribeIds;
            userNamesValues[i] = map; // Update the map in the list
          }
          found = true;
          break;
        }
      }

      if (!found) {
        // If the userNameKey doesn't exist, add a new map
        userNamesValues.add({
          userNameKey: [tribeModel.tribeId],
        });
      }

      // Add the updated data to the batch
      batch.set(
        userNamesDocRef,
        {'values': userNamesValues},
        SetOptions(merge: true),
      );

      // 2. Update 'tribe-types' document
      final tribeTypesDocRef =
          typeaheadCollection.doc(FirestoreCollections.typeAheadTypesDoc);
      final tribeTypeKey =
          (tribeModel.type ?? 'No tribal type saving').sanitizeFieldName();

      // Read existing data before the batch
      final tribeTypesSnapshot = await tribeTypesDocRef.get();
      final data = tribeTypesSnapshot.data();

      var values = <dynamic>[];
      if (data != null && data['values'] != null) {
        values = data['values'] as List<dynamic>;
      }

      // Modify the values
      found = false;
      for (var i = 0; i < values.length; i++) {
        final map = values[i] as Map<String, dynamic>;
        if (map.containsKey(tribeTypeKey)) {
          final tribeIds = List<dynamic>.from(map[tribeTypeKey] as List);
          if (!tribeIds.contains(tribeModel.tribeId)) {
            tribeIds.add(tribeModel.tribeId);
            map[tribeTypeKey] = tribeIds;
            values[i] = map; // Update the map in the list
          }
          found = true;
          break;
        }
      }

      if (!found) {
        values.add({
          tribeTypeKey: [tribeModel.tribeId],
        });
      }

      // Add the updated data to the batch
      batch.set(
        tribeTypesDocRef,
        {'values': values},
        SetOptions(merge: true),
      );

      // 3. Update 'tribe-names' document
      final tribeNamesDocRef =
          typeaheadCollection.doc(FirestoreCollections.tribeNames);
      final tribeNameKey = tribeModel.name.sanitizeFieldName();

      // Read existing data before the batch
      final tribeNamesSnapshot = await tribeNamesDocRef.get();
      final tribeNamesData = tribeNamesSnapshot.data();

      var tribeNamesValues = <dynamic>[];
      if (tribeNamesData != null && tribeNamesData['values'] != null) {
        tribeNamesValues = tribeNamesData['values'] as List<dynamic>;
      }

      // Modify the values
      found = false;
      for (var i = 0; i < tribeNamesValues.length; i++) {
        final map = tribeNamesValues[i] as Map<String, dynamic>;
        if (map.containsKey(tribeNameKey)) {
          final tribeIds = List<dynamic>.from(map[tribeNameKey] as List);
          if (!tribeIds.contains(tribeModel.tribeId)) {
            tribeIds.add(tribeModel.tribeId);
            map[tribeNameKey] = tribeIds;
            tribeNamesValues[i] = map; // Update the map in the list
          }
          found = true;
          break;
        }
      }

      if (!found) {
        tribeNamesValues.add({
          tribeNameKey: [tribeModel.tribeId],
        });
      }

      // Add the updated data to the batch
      batch.set(
        tribeNamesDocRef,
        {'values': tribeNamesValues},
        SetOptions(merge: true),
      );

      return const Right(null);
    } catch (error, stackTrace) {
      logger.logError(
        message: 'Error adding search elements to batch',
        error: error,
        stackTrace: stackTrace,
      );
      return const Left(
        BaseApiError<PlatformErrorReason>(
          reason: PlatformErrorReason.unknownError,
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError, TribeModel?>> getLastRegisteredTribeByUserId(
    String userId,
  ) async {
    try {
      final tribeQuery = await firestore
          .collection(FirestoreCollections.tribes)
          .where(TribeModel.fieldOwnerId, isEqualTo: userId)
          .orderBy(TribeModel.fieldCreatedAt, descending: true)
          .limit(1)
          .get();

      if (tribeQuery.docs.isEmpty) {
        return right(null);
      }

      final tribeData = tribeQuery.docs.first.data();
      final tribe = TribeModel.fromJson(tribeData);

      return Right(tribe);
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error fetching last registered tribe',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError<FirebaseErrorReason>(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
        ),
      );
    } catch (e, stackTrace) {
      logger.logError(
        message: 'Error fetching last registered tribe',
        error: e,
        stackTrace: stackTrace,
      );
      return const Left(
        BaseApiError<TribeErrorReason>(reason: TribeErrorReason.unknownError),
      );
    }
  }

  @override
  Future<Either<BaseApiError<dynamic>, UserTribes>> getTribesForUser(
    String userId,
  ) async {
    try {
      // Initialize lists to hold the tribes
      final ownedTribes = <TribeModel>[];
      final memberTribes = <TribeModel>[];
      const pageSize = 20;

      // Fetch tribes where the user is the owner
      final ownedTribesQuery = firestore
          .collection(FirestoreCollections.tribes)
          .where(TribeModel.fieldOwnerId, isEqualTo: userId)
          .orderBy(TribeModel.fieldCreatedAt, descending: true)
          .limit(pageSize)
          .get();

      // Fetch tribes where the user is a member
      final memberTribesQuery = firestore
          .collection(FirestoreCollections.tribes)
          .where(TribeModel.fieldMembers, arrayContains: userId)
          .orderBy(TribeModel.fieldCreatedAt, descending: true)
          .limit(pageSize)
          .get();

      // Execute both queries in parallel
      final results = await Future.wait([ownedTribesQuery, memberTribesQuery]);

      final ownedSnapshot = results[0];
      final memberSnapshot = results[1];

      // Process owned tribes
      for (final doc in ownedSnapshot.docs) {
        ownedTribes.add(TribeModel.fromJson(doc.data()));
      }

      // Process member tribes
      for (final doc in memberSnapshot.docs) {
        // Exclude tribes where the user is also the owner
        if (doc.data()[TribeModel.fieldOwnerId] != userId) {
          memberTribes.add(TribeModel.fromJson(doc.data()));
        }
      }

      // Sort the lists by creation date in descending order
      ownedTribes.sort((a, b) => _compareCreatedAt(b.createdAt, a.createdAt));
      memberTribes.sort((a, b) => _compareCreatedAt(b.createdAt, a.createdAt));

      // Create the UserTribes object
      final userTribes = UserTribes(
        ownedTribes: ownedTribes,
        memberTribes: memberTribes,
      );

      // Return the result
      return Right(userTribes);
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error fetching tribes for user',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
        ),
      );
    } catch (error, stackTrace) {
      logger.logError(
        message: 'Error fetching tribes for user',
        error: error,
        stackTrace: stackTrace,
      );
      return const Left(
        BaseApiError<PlatformErrorReason>(
          reason: PlatformErrorReason.unknownError,
        ),
      );
    }
  }

  // Helper function to compare createdAt with null safety
  int _compareCreatedAt(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return b.compareTo(a);
  }
}
