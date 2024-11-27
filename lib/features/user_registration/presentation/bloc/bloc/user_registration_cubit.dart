import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/models/storage_paths.dart';
import 'package:online_tribes/core/services/storage_service.dart';
import 'package:online_tribes/features/authentication/data/models/auth_error_reason.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_service.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_error_reason.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/get_user_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/is_user_name_taken_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/update_user_usecase.dart';
import 'package:online_tribes/features/shared/usecases/upload_file_usecase.dart';
import 'package:online_tribes/features/user_registration/domain/entities/user_registration_step_enum.dart';
import 'package:online_tribes/features/user_registration/presentation/bloc/bloc/user_registration_state.dart';

class UserRegistrationCubit extends Cubit<UserRegistrationState> {
  final UpdateUserUseCase updateUserUseCase;
  final IsUserNameTakenUseCase isUserNameTakenUseCase;
  final UploadFileUseCase uploadFileUseCase;
  final GetUserUseCase getUserUseCase;
  final LoggerService logger;
  final IStorageService storageService;

  UserRegistrationCubit({
    required this.uploadFileUseCase,
    required this.isUserNameTakenUseCase,
    required this.updateUserUseCase,
    required this.getUserUseCase,
    required this.logger,
    required this.storageService,
  }) : super(const UserRegistrationState.initial());

  /// Loads user registration data from Firebase
  Future<void> loadUserRegistrationData() async {
    emit(const UserRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const UserRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    // Fetch the current user data
    final result = await getUserUseCase.call(userId);

    result.fold(
      (error) {
        emit(UserRegistrationState.failure(error));
      },
      (user) {
        emit(UserRegistrationState.userDataLoaded(user));
      },
    );
  }

  /// Saves Name, Gender, Place, and Profile Picture
  Future<void> saveNameTab({
    required String username,
    required String gender,
    required String myPlace,
    required File profilePictureFile,
  }) async {
    emit(const UserRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const UserRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    final isUserNameTakenResult =
        await isUserNameTakenUseCase(username: username);
    await isUserNameTakenResult.fold(
      (error) {
        emit(UserRegistrationState.failure(error));
      },
      (isUserNameTaken) async {
        if (isUserNameTaken) {
          emit(
            const UserRegistrationState.failure(
              BaseApiError<UserErrorReason>(
                reason: UserErrorReason.userNameExist,
              ),
            ),
          );
          return;
        } else {
          final getUserResult = await getUserUseCase.call(userId);

          await getUserResult.fold(
            (error) {
              emit(UserRegistrationState.failure(error));
            },
            (currentUser) async {
              // Upload profile picture
              final uploadResult = await uploadFileUseCase.call(
                UploadFileParams(
                  storagePath: StoragePaths.userProfilePicturePath(userId),
                  file: profilePictureFile,
                ),
              );

              await uploadResult.fold(
                (error) {
                  emit(UserRegistrationState.failure(error));
                },
                (profilePictureUrl) async {
                  // Build user update with existing data and new profile information
                  final updatedUser = currentUser.copyWith(
                    username: username.capitalize(),
                    information: currentUser.information?.copyWith(
                      profilePictureUrl: profilePictureUrl,
                    ),
                    lastRegistrationStepIndex: UserRegistrationStep.age.index,
                  );

                  final resultOrError = await updateUserUseCase.call(
                    userId: userId,
                    userData: updatedUser.toJson(),
                  );

                  resultOrError.fold(
                    (error) {
                      emit(UserRegistrationState.failure(error));
                    },
                    (_) {
                      emit(
                        UserRegistrationState.submittingSuccess(
                          updatedUser,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  /// Saves Age and Languages
  Future<void> saveAgeTab({
    required List<String> languages,
    required double age,
  }) async {
    emit(const UserRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const UserRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    // Fetch current user data
    final getUserResult = await getUserUseCase.call(userId);

    await getUserResult.fold(
      (error) {
        emit(UserRegistrationState.failure(error));
      },
      (currentUser) async {
        // Build user update with existing data and new age and languages
        final updatedUser = currentUser.copyWith(
          information: currentUser.information?.copyWith(
            age: age.roundToDouble(),
            languages: languages,
          ),
          lastRegistrationStepIndex: UserRegistrationStep.bio.index,
        );

        final resultOrError = await updateUserUseCase.call(
          userId: userId,
          userData: updatedUser.toJson(),
        );

        resultOrError.fold(
          (error) {
            emit(UserRegistrationState.failure(error));
          },
          (_) {
            emit(UserRegistrationState.submittingSuccess(updatedUser));
          },
        );
      },
    );
  }

  /// Saves Bio
  Future<void> saveBioTab({
    required String bio,
  }) async {
    emit(const UserRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const UserRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    // Fetch current user data
    final getUserResult = await getUserUseCase.call(userId);

    await getUserResult.fold(
      (error) {
        emit(UserRegistrationState.failure(error));
      },
      (currentUser) async {
        // Build user update with existing data and new bio
        final updatedUser = currentUser.copyWith(
          information: currentUser.information?.copyWith(
            bio: bio,
          ),
          lastRegistrationStepIndex: UserRegistrationStep.hobbies.index,
        );

        final resultOrError = await updateUserUseCase.call(
          userId: userId,
          userData: updatedUser.toJson(),
        );

        resultOrError.fold(
          (error) {
            emit(UserRegistrationState.failure(error));
          },
          (_) {
            emit(UserRegistrationState.submittingSuccess(updatedUser));
          },
        );
      },
    );
  }

  /// Saves Hobbies
  Future<void> saveHobbiesTab({
    required List<String> hobbies,
  }) async {
    emit(const UserRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const UserRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    // Fetch current user data
    final getUserResult = await getUserUseCase.call(userId);

    await getUserResult.fold(
      (error) {
        emit(UserRegistrationState.failure(error));
      },
      (currentUser) async {
        // Build user update with existing data and new hobbies
        final updatedUser = currentUser.copyWith(
          information: currentUser.information?.copyWith(
            hobbies: hobbies,
          ),
          lastRegistrationStepIndex:
              UserRegistrationStep.postRegistration.index,
        );

        final resultOrError = await updateUserUseCase.call(
          userId: userId,
          userData: updatedUser.toJson()
            ..addAll({'createdAt': FieldValue.serverTimestamp()}),
        );

        resultOrError.fold(
          (error) {
            emit(UserRegistrationState.failure(error));
          },
          (_) {
            emit(UserRegistrationState.submittingSuccess(updatedUser));
          },
        );
      },
    );
  }

  /// Saves Hobbies
  Future<void> saveRegistrationFinished() async {
    emit(const UserRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const UserRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    // Fetch current user data
    final getUserResult = await getUserUseCase.call(userId);

    await getUserResult.fold(
      (error) {
        emit(UserRegistrationState.failure(error));
      },
      (currentUser) async {
        // Build user update with existing data and new hobbies
        final updatedUser = currentUser.copyWith(
          information: currentUser.information?.copyWith(),
          lastRegistrationStepIndex: UserRegistrationStep.done.index,
        );

        final resultOrError = await updateUserUseCase.call(
          userId: userId,
          userData: updatedUser.toJson(),
        );

        resultOrError.fold(
          (error) {
            emit(UserRegistrationState.failure(error));
          },
          (_) {
            emit(UserRegistrationState.submittingSuccess(updatedUser));
          },
        );
      },
    );
  }

  /// Shows an error state
  void showError(BaseApiError error) {
    emit(UserRegistrationState.failure(error));
  }
}
