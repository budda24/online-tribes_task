import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/firebase_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/firebase_error_reason.dart';
import 'package:online_tribes/core/models/storage_paths.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/user_update_builder.dart';
import 'package:online_tribes/features/shared/usecases/upload_file_usecase.dart';
import 'package:online_tribes/features/user_profile/presentation/cubit/user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UploadFileUseCase uploadFileUseCase;
  final UserRepository userRepository;
  final TribeRepository tribeRepository;

  UserProfileCubit({
    required this.uploadFileUseCase,
    required this.userRepository,
    required this.tribeRepository,
  }) : super(const UserProfileState.initial());

  Future<void> getUserData(String userId) async {
    // Existing getUserData handler
    final userResult = await userRepository.getUser(userId);
    await userResult.fold(
      (error) {
        emit(UserProfileState.error(error));
      },
      (user) async {
        emit(const UserProfileState.loading());

        final userTribesResult = await tribeRepository.getTribesForUser(userId);

        userTribesResult.fold(
          (error) {
            emit(UserProfileState.error(error));
          },
          (userTribes) {
            emit(UserProfileState.success(user: user, userTribes: userTribes));
          },
        );
      },
    );
  }

  Future<void> updateUser(UserModel user) async {
    // Implementing updateUser event handling
    try {
      emit(const UserProfileState.loading());
      final userId = userRepository.getUserId;

      // Fetch the existing user data to ensure we don't overwrite with nulls
      final currentUserResult = await userRepository.getUser(userId);
      if (currentUserResult.isLeft()) {
        emit(
          UserProfileState.error(
            currentUserResult as BaseApiError<dynamic>,
          ),
        );
        return;
      }

      final currentUser = currentUserResult.fold((_) => null, (r) => r);

      // Build the update data using UserUpdateBuilder, only setting values that are not null
      final userUpdateBuilder = UserUpdateBuilder()
        ..setGender(
          user.information?.gender ?? currentUser?.information?.gender,
        )
        ..setBio(
          user.information?.bio ?? currentUser?.information?.bio,
        )
        ..setHobbies(
          user.information?.hobbies ?? currentUser?.information?.hobbies,
        )
        ..setMyPlace(
          user.information?.myPlace ?? currentUser?.information?.myPlace,
        )
        ..setProfilePictureUrl(
          user.information?.profilePictureUrl ??
              currentUser?.information?.profilePictureUrl,
        );

      final updateData = userUpdateBuilder.build();

      // Call the updateUserUseCase with userId and updateData
      final resultOrError = await userRepository.updateUser(
        userId,
        updateData,
      );

      await resultOrError.fold(
        (error) {
          // Handle failure by emitting the error state
          emit(UserProfileState.error(error));
        },
        (_) async {
          // On success, fetch the updated user data
          final userResult = await userRepository.getUser(userId);
          await userResult.fold(
            (error) {
              emit(UserProfileState.error(error));
            },
            (user) async {
              // Emit the updated user data
              final userTribesResult =
                  await tribeRepository.getTribesForUser(userId);

              userTribesResult.fold(
                (error) {
                  emit(UserProfileState.error(error));
                },
                (userTribes) {
                  emit(
                    UserProfileState.success(
                      user: user,
                      userTribes: userTribes,
                    ),
                  );
                },
              );
            },
          );
        },
      );
    } on FirebaseException catch (e) {
      // Handle Firebase-specific errors
      emit(
        UserProfileState.error(
          BaseApiError<FirebaseErrorReason>(
            reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
          ),
        ),
      );
    } catch (e) {
      // Handle any other exceptions
      emit(
        const UserProfileState.error(
          BaseApiError<FirebaseErrorReason>(
            reason: FirebaseErrorReason.unknownError,
          ),
        ),
      );
    }
  }

  Future<void> updateProfilePicture(
    File profilePictureFile,
    UserModel user,
  ) async {
    emit(const UserProfileState.loading());

    if (user.userId == null) return;

    final uploadResult = await uploadFileUseCase.call(
      UploadFileParams(
        storagePath: StoragePaths.userProfilePicturePath(user.userId!),
        file: profilePictureFile,
      ),
    );
    await uploadResult.fold(
      (error) {
        emit(UserProfileState.error(error));
      },
      (profilePictureUrl) async {
        final userData =
            UserUpdateBuilder().setProfilePictureUrl(profilePictureUrl).build();
        final updateResult = await userRepository.updateUser(
          userRepository.getUserId,
          userData,
        );
        await updateResult.fold(
          (error) {
            emit(UserProfileState.error(error));
          },
          (r) async {
            final userTribesResult =
                await tribeRepository.getTribesForUser(user.userId!);

            userTribesResult.fold(
              (error) {
                emit(UserProfileState.error(error));
              },
              (userTribes) {
                emit(
                  UserProfileState.success(
                    user: user.updateInformation(
                      (information) => information.copyWith(
                        profilePictureUrl: profilePictureUrl,
                      ),
                    ),
                    userTribes: userTribes,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
