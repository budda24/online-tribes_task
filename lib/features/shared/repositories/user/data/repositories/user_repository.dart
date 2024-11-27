import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/firebase_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/firebase_error_reason.dart';
import 'package:online_tribes/core/error/reasons/platform_error_reason.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<BaseApiError<dynamic>, void>> saveUser(UserModel userModel);
  Future<Either<BaseApiError<dynamic>, UserModel>> getUser(String userId);
  Future<Either<BaseApiError<dynamic>, void>> updateUser(
    String userId,
    Map<String, dynamic> userData,
  );
  Future<Either<BaseApiError<dynamic>, bool>> isUsernameTaken(
    String username,
  );
  String get getUserId;
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore firestore;
  final LoggerService logger;

  UserRepositoryImpl({
    required this.firestore,
    required this.logger,
  });

  @override
  Future<Either<BaseApiError<dynamic>, void>> saveUser(
    UserModel userModel,
  ) async {
    try {
      // Add the user document
      final userDocRef = firestore
          .collection(FirestoreCollections.users)
          .doc(userModel.userId);
      await userDocRef.set(userModel.toJson());

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error saving user data to Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(
            e,
          ),
        ),
      );
    } catch (error, stackTrace) {
      logger.logError(
        message: 'Error saving user data to Firestore',
        error: error,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError<String>(
          reason: error.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError<dynamic>, UserModel>> getUser(
    String userId,
  ) async {
    try {
      final userDoc = await firestore
          .collection(FirestoreCollections.users)
          .doc(userId)
          .get();
      if (userDoc.exists) {
        final userModel = UserModel.fromJson(userDoc.data()!);
        return Right(userModel);
      } else {
        return const Left(
          BaseApiError(
            reason: FirebaseErrorReason.notFound,
          ),
        );
      }
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error fetching user data from Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(
            e,
          ),
        ),
      );
    }
  }

// Update the user without checking for username uniqueness
  @override
  Future<Either<BaseApiError<dynamic>, void>> updateUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final userDocRef =
          firestore.collection(FirestoreCollections.users).doc(userId);

      // Update the user's document with the new data
      await userDocRef.update(userData);

      return const Right(null);
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error updating user data in Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError<FirebaseErrorReason>(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(
            e,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<BaseApiError<dynamic>, bool>> isUsernameTaken(
    String username,
  ) async {
    try {
      // Query the 'users' collection for documents where 'username' equals the provided username
      final querySnapshot = await firestore
          .collection(FirestoreCollections.users)
          .where(UserModel.fieldUsername, isEqualTo: username.capitalize())
          .limit(1) // Limit to 1 result for efficiency
          .get();

      final isTaken = querySnapshot.docs.isNotEmpty;

      return Right(isTaken);
    } on FirebaseException catch (e, stackTrace) {
      logger.logError(
        message: 'Error checking username in Firestore',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        BaseApiError<FirebaseErrorReason>(
          reason: FirebaseErrorReasonMapper.mapFirebaseError(
            e,
          ),
        ),
      );
    } catch (e, stackTrace) {
      logger.logError(
        message: 'Unknown error checking username in Firestore',
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
  String get getUserId => FirebaseAuth.instance.currentUser!.uid;
}
