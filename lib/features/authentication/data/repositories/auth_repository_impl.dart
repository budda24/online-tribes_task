import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/google_auth_service.dart';
import 'package:online_tribes/core/services/rate_limiting_service.dart';
import 'package:online_tribes/features/authentication/data/models/auth_error_reason.dart';
import 'package:online_tribes/features/authentication/data/models/mappers/auth_error_mapper.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_repository.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_service.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/get_user_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/save_user_usecase.dart';

@injectable
class AuthRepositoryImpl implements AuthRepository {
  final IAuthService authService;
  final FirebaseFirestore firestore;
  final LoggerService logger;
  final RateLimitingService rateLimitingService;
  final SaveUserUseCase saveUserUseCase;
  final GetUserUseCase getUserUseCase;
  final GoogleAuthService googleAuthService;

  AuthRepositoryImpl(
    this.authService,
    this.firestore,
    this.logger,
    this.rateLimitingService,
    this.saveUserUseCase,
    this.getUserUseCase,
    this.googleAuthService,
  );

  @override
  Future<Either<BaseApiError<dynamic>, void>> signOut() async {
    try {
      logger.logInfo(message: 'Signing out user');
      await authService.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      logger.logError(
        message: 'Error signing out user',
        error: e,
        stackTrace: stackTrace,
      );
      final errorReason = AuthErrorMapper.mapFirebaseErrorToAuthError(e.code);
      return Left(
        BaseApiError(
          reason: errorReason,
        ),
      );
    }
  }

  @override
  User? get user => authService.user;

  @override
  Future<Either<BaseApiError, UserCredential>> signInWithGoogle() async {
    try {
      final authServiceResponse = await googleAuthService.signIn();

      return authServiceResponse.fold(
        left,
        (authServiceUser) async {
          // Check rate limit before proceeding
          final isRateLimited =
              await rateLimitingService.checkRateLimit(authServiceUser.email);
          if (isRateLimited) {
            logger.logWarning(
              message:
                  'Rate limit exceeded for email: ${authServiceUser.email}',
            );
            return left(
              const BaseApiError(
                reason: AuthErrorReason.tooManyRequests,
              ),
            );
          }

          final credential = await authService
              .signInWithCredential(authServiceUser.authCredential);

          if (credential.user != null) {
            return right(credential);
          } else {
            logger.logWarning(
              message: 'User sign in failed: No user returned',
            );
            return left(
              const BaseApiError(
                reason: AuthErrorReason.unknownError,
              ),
            );
          }
        },
      );
    } on FirebaseAuthException catch (e, stackTrace) {
      logger.logError(
        message: 'Error signing in with Google',
        error: e,
        stackTrace: stackTrace,
      );
      final errorReason = AuthErrorMapper.mapFirebaseErrorToAuthError(e.code);

      return Left(
        BaseApiError(
          reason: errorReason,
        ),
      );
    }
  }
}
