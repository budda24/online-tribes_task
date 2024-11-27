import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_tribes/core/config/firestore_collections.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/reasons/platform_error_reason.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/models/storage_paths.dart';
import 'package:online_tribes/features/authentication/data/models/auth_error_reason.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_service.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_error_reason.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/tribe/domain/usecases/create_tribe_usecase.dart';
import 'package:online_tribes/features/shared/repositories/tribe/domain/usecases/is_tribe_name_taken_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/get_user_usecase.dart';
import 'package:online_tribes/features/shared/usecases/upload_file_usecase.dart';
import 'package:online_tribes/features/tribe_registration/domain/entities/tribe_registration_step.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/attach_tribe_it_to_search_elements_usecase.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/get_tribe_usecase.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/update_tribe_usecase.dart';
import 'package:online_tribes/features/tribe_registration/presentation/bloc/bloc/tribe_registration_state.dart';
import 'package:uuid/uuid.dart';

class TribeRegistrationCubit extends Cubit<TribeRegistrationState> {
  final UpdateTribeUseCase updateTribeUseCase;
  final GetLastRegisteredTribeUseCase getLastRegisteredTribeUseCase;
  final CreateTribeUseCase createTribeUseCase;
  final IsTribeNameTakenUseCase isTribeNameTakenUseCase;
  final UploadFileUseCase uploadFileUseCase;
  final LoggerService logger;
  final GetUserUseCase getUserUseCase;
  final FirebaseFirestore firestore;
  final AttachTribeToSearchElementsUseCase attachTribeToSearchElementsUseCase;

  // Private variable to hold the current tribe
  TribeModel? _currentTribe;

  TribeRegistrationCubit({
    required this.updateTribeUseCase,
    required this.getLastRegisteredTribeUseCase,
    required this.createTribeUseCase,
    required this.isTribeNameTakenUseCase,
    required this.uploadFileUseCase,
    required this.getUserUseCase,
    required this.logger,
    required this.firestore,
    required this.attachTribeToSearchElementsUseCase,
  }) : super(const TribeRegistrationState.initial());

  Future<TribeModel?> loadTribeRegistrationData() async {
    emit(const TribeRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return null;
    }

    // Fetch the last tribe data associated with the user
    final result = await getLastRegisteredTribeUseCase.call(userId);

    return result.fold(
      (error) {
        emit(TribeRegistrationState.failure(error));
        return null;
      },
      (tribe) {
        _currentTribe = tribe;
        if ((tribe.lastTribeRegistrationStepIndex ?? 0) ==
            TribeRegistrationStep.postRegistration.index) {
          emit(TribeRegistrationState.tribeDataLoaded(TribeModel.empty()));
        } else {
          emit(TribeRegistrationState.tribeDataLoaded(tribe));
        }

        return tribe;
      },
    );
  }

  /// Saves the name and language information for the tribe.
  Future<void> saveNameTab(String name, String language) async {
    emit(const TribeRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    // Check if tribe name is taken
    final isTribeNameTakenResult =
        await isTribeNameTakenUseCase.call(tribeName: name);

    await isTribeNameTakenResult.fold(
      (error) {
        emit(TribeRegistrationState.failure(error));
      },
      (isTribeNameTaken) async {
        if (isTribeNameTaken) {
          emit(
            const TribeRegistrationState.failure(
              BaseApiError<TribeErrorReason>(
                reason: TribeErrorReason.tribeNameExist,
              ),
            ),
          );
        } else {
          final newTribeId = const Uuid().v4();
          final newTribe = TribeModel(
            name: name.capitalize(),
            language: language,
            ownerId: userId,
            tribeId: newTribeId,
            lastTribeRegistrationStepIndex:
                TribeRegistrationStep.criteria.index,
            members: [],
          );

          final result = await createTribeUseCase.call(
            newTribe,
            newTribeId,
          );

          result.fold(
            (error) {
              emit(TribeRegistrationState.failure(error));
            },
            (_) {
              _currentTribe = newTribe;
              emit(TribeRegistrationState.submittingSuccess(newTribe));
            },
          );
        }
      },
    );
  }

  /// Saves the criteria and sign picture for the tribe.
  Future<void> saveCriteriaTab(
    String tribeType,
    String criteria,
    File signPictureFile,
  ) async {
    emit(const TribeRegistrationState.loading());

    final currentTribe = _currentTribe;
    if (currentTribe == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<PlatformErrorReason>(
            reason: PlatformErrorReason.unknownError,
          ),
        ),
      );
      return;
    }

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    // Upload sign picture
    final uploadResult = await uploadFileUseCase.call(
      UploadFileParams(
        storagePath: StoragePaths.tribalSignPicturePath(currentTribe.tribeId),
        file: signPictureFile,
      ),
    );

    await uploadResult.fold(
      (error) {
        emit(TribeRegistrationState.failure(error));
      },
      (signPictureUrl) async {
        // Build updated tribe data
        final updatedTribe = currentTribe.copyWith(
          type: tribeType,
          membershipCriteria: criteria,
          signUrl: signPictureUrl,
          lastTribeRegistrationStepIndex: TribeRegistrationStep.bio.index,
        );

        final batch = firestore.batch();

        // Update tribe data in Firestore
        final resultOrError = await updateTribeUseCase.call(
          tribeId: currentTribe.tribeId,
          tribeData: updatedTribe.toJson(),
          batch: batch,
        );

        await resultOrError.fold(
          (error) {
            emit(TribeRegistrationState.failure(error));
          },
          (_) async {
            try {
              await batch.commit();

              _currentTribe = updatedTribe;
              emit(
                TribeRegistrationState.submittingSuccess(updatedTribe),
              );
            } catch (e, stackTrace) {
              logger.logError(
                message: 'Error committing batch',
                error: e,
                stackTrace: stackTrace,
              );
              emit(
                const TribeRegistrationState.failure(
                  BaseApiError<PlatformErrorReason>(
                    reason: PlatformErrorReason.unknownError,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Saves the bio information for the tribe.
  Future<void> saveBioTab(String bio) async {
    emit(const TribeRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    final currentTribe = _currentTribe;
    if (currentTribe == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<PlatformErrorReason>(
            reason: PlatformErrorReason.unknownError,
          ),
        ),
      );
      return;
    }

    final updatedTribe = currentTribe.copyWith(
      bio: bio,
      lastTribeRegistrationStepIndex: TribeRegistrationStep.theme.index,
    );

    final batch = firestore.batch();

    final resultOrError = await updateTribeUseCase.call(
      tribeId: currentTribe.tribeId,
      tribeData: updatedTribe.toJson(),
      batch: batch,
    );

    await resultOrError.fold(
      (error) {
        emit(TribeRegistrationState.failure(error));
      },
      (_) async {
        try {
          await batch.commit();
          _currentTribe = updatedTribe;
          emit(
            TribeRegistrationState.submittingSuccess(updatedTribe),
          );
        } catch (e, stackTrace) {
          logger.logError(
            message: 'Error committing batch',
            error: e,
            stackTrace: stackTrace,
          );
          emit(
            const TribeRegistrationState.failure(
              BaseApiError<PlatformErrorReason>(
                reason: PlatformErrorReason.unknownError,
              ),
            ),
          );
        }
      },
    );
  }

  /// Saves the themes selected for the tribe.
  Future<void> saveThemeTab(List<String> themes) async {
    emit(const TribeRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    final currentTribe = _currentTribe;
    if (currentTribe == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<PlatformErrorReason>(
            reason: PlatformErrorReason.unknownError,
          ),
        ),
      );
      return;
    }

    // Fetch the user's name
    final userResult = await getUserUseCase(userId);
    await userResult.fold(
      (error) {
        emit(TribeRegistrationState.failure(error));
      },
      (user) async {
        final userName = user.username ?? 'Unknown';

        // Build updated tribe data with ownerName
        final updatedTribe = currentTribe.copyWith(
          themes: themes,
          ownerName: userName, // Update the ownerName here
          lastTribeRegistrationStepIndex:
              TribeRegistrationStep.postRegistration.index,
        );

        // Create a WriteBatch
        final batch = firestore.batch();

        // Update the tribe using the batch
        final updateResult = await updateTribeUseCase.call(
          tribeId: currentTribe.tribeId,
          tribeData: updatedTribe.toJson(),
          batch: batch,
        );

        await updateResult.fold(
          (error) {
            emit(TribeRegistrationState.failure(error));
          },
          (_) async {
            // Attach tribe to search elements using the same batch
            final attachResult = await attachTribeToSearchElementsUseCase.call(
              tribeModel: updatedTribe,
              userName: userName,
              batch: batch,
            );

            await attachResult.fold(
              (error) {
                emit(TribeRegistrationState.failure(error));
              },
              (_) async {
                // Commit the batch
                try {
                  batch.update(
                    firestore
                        .collection(FirestoreCollections.tribes)
                        .doc(updatedTribe.tribeId),
                    {
                      TribeModel.fieldCreatedAt: FieldValue.serverTimestamp(),
                    },
                  );
                  await batch.commit();
                  _currentTribe = updatedTribe;

                  emit(
                    TribeRegistrationState.submittingSuccess(
                      updatedTribe,
                    ),
                  );
                } catch (e, stackTrace) {
                  logger.logError(
                    message: 'Error committing batch',
                    error: e,
                    stackTrace: stackTrace,
                  );
                  emit(
                    const TribeRegistrationState.failure(
                      BaseApiError<PlatformErrorReason>(
                        reason: PlatformErrorReason.unknownError,
                      ),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Future<void> saveRegistrationFinish() async {
    emit(const TribeRegistrationState.loading());

    final userId = getIt<IAuthService>().user?.uid;
    if (userId == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<AuthErrorReason>(
            reason: AuthErrorReason.unauthenticatedUser,
          ),
        ),
      );
      return;
    }

    final currentTribe = _currentTribe;
    if (currentTribe == null) {
      emit(
        const TribeRegistrationState.failure(
          BaseApiError<PlatformErrorReason>(
            reason: PlatformErrorReason.unknownError,
          ),
        ),
      );
      return;
    }

    final updatedTribe = currentTribe.copyWith(
      lastTribeRegistrationStepIndex: TribeRegistrationStep.finished.index,
    );

    final batch = firestore.batch();

    final resultOrError = await updateTribeUseCase.call(
      tribeId: currentTribe.tribeId,
      tribeData: updatedTribe.toJson(),
      batch: batch,
    );

    await resultOrError.fold(
      (error) {
        emit(TribeRegistrationState.failure(error));
      },
      (_) async {
        try {
          await batch.commit();
          _currentTribe = updatedTribe;
          emit(
            TribeRegistrationState.submittingSuccess(updatedTribe),
          );
        } catch (e, stackTrace) {
          logger.logError(
            message: 'Error committing batch',
            error: e,
            stackTrace: stackTrace,
          );
          emit(
            const TribeRegistrationState.failure(
              BaseApiError<PlatformErrorReason>(
                reason: PlatformErrorReason.unknownError,
              ),
            ),
          );
        }
      },
    );
  }

  /// Shows an error state.
  void showError(BaseApiError error) {
    emit(TribeRegistrationState.failure(error));
  }
}
