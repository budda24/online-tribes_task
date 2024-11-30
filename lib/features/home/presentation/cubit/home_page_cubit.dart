import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/firebase_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/firebase_error_reason.dart';
import 'package:online_tribes/core/error/reasons/freezed_error_reason.dart';
import 'package:online_tribes/features/home/presentation/cubit/home_page_state.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_error_reason.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_set_up_status.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';

@injectable
class HomePageCubit extends Cubit<HomePageState> {
  final UserRepository _userRepository;
  final TribeRepository _tribeRepository;

  HomePageCubit({
    required UserRepository userRepository,
    required TribeRepository tribeRepository,
  })  : _userRepository = userRepository,
        _tribeRepository = tribeRepository,
        super(const HomePageState.initial());

  Future<void> loadUserData(String tribeId) async {
    final userId = _userRepository.getUserId;

    try {
      emit(const HomePageState.loading());
      final userResult = await _userRepository.getUser(userId);
      Either<BaseApiError, TribeModel?> tribeData;
      if (tribeId != '') {
        tribeData = await _tribeRepository.getTribe(tribeId);
      } else {
        tribeData = await _tribeRepository.getLastRegisteredTribeByUserId(userId);
      }

      userResult.fold<void>(
        (failure) {
          emit(
            HomePageState.error(
              failure,
            ),
          );
        },
        (user) {
          tribeData.fold<void>(
            (failure) {
              HomePageState.error(
                failure,
              );
            },
            (tribe) {
              if (tribe == null) {
                emit(
                  const HomePageState.error(
                    BaseApiError<TribeErrorReason>(
                      reason: TribeErrorReason.tribeNotLoaded,
                    ),
                  ),
                );
              }
              emit(
                HomePageState.loaded(
                  tribe: tribe!,
                  user: user,
                  stateId: UniqueKey().toString(),
                ),
              );
            },
          );
        },
      );
    } on FirebaseException catch (e) {
      emit(
        HomePageState.error(
          BaseApiError<FirebaseErrorReason>(
            reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
          ),
        ),
      );
    } catch (error) {
      emit(
        const HomePageState.error(
          BaseApiError<FirebaseErrorReason>(
            reason: FirebaseErrorReason.unknownError,
          ),
        ),
      );
    }
  }

  Future<void> updateTribeSetUpStatus(
    TribeSetUpStatus tribeSetUpStatus,
  ) async {
    final currentState = state;
    if (currentState is Loaded) {
      final updatedTribe = currentState.tribe.copyWith(
        tribeSetUpStatus: tribeSetUpStatus,
      );

      emit(currentState.copyWith(tribe: updatedTribe));

      try {
        emit(
          const HomePageState.loading(),
        );
        await _tribeRepository.updateTribe(
          updatedTribe.tribeId,
          updatedTribe.toJson(),
        );

        emit(
          HomePageState.loaded(tribe: updatedTribe, user: currentState.user, stateId: UniqueKey().toString()),
        );
      } on FirebaseException catch (e) {
        emit(
          HomePageState.error(
            BaseApiError<FirebaseErrorReason>(
              reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
            ),
          ),
        );
        emit(currentState);
      } catch (error) {
        emit(
          const HomePageState.error(
            BaseApiError<FirebaseErrorReason>(
              reason: FirebaseErrorReason.unknownError,
            ),
          ),
        );

        emit(currentState);
      }
    } else {
      emit(
        const HomePageState.error(
          BaseApiError<FreezedErrorReason>(
            reason: FreezedErrorReason.copyWithOnStateNotLoaded,
          ),
        ),
      );
    }
  }
}
