import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/error/mappers/firebase_error_mapper.dart';
import 'package:online_tribes/core/error/reasons/firebase_error_reason.dart';
import 'package:online_tribes/features/context_menu/presentation/cubit/context_menu_state.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';

class ContextMenuCubit extends Cubit<ContextMenuState> {
  final TribeRepository _tribeRepository;
  final UserRepository _userRepository;

  ContextMenuCubit({
    required TribeRepository tribeRepository,
    required UserRepository userRepository,
  })  : _tribeRepository = tribeRepository,
        _userRepository = userRepository,
        super(const ContextMenuState.initial());

  Future<void> loadTribeData() async {
    final userId = _userRepository.getUserId;
    try {
      emit(const ContextMenuState.loading());
      final tribeData =
          await _tribeRepository.getLastRegisteredTribeByUserId(userId);
      tribeData.fold(
        (failure) {
          emit(ContextMenuState.error(failure));
        },
        (tribe) {
          emit(
            ContextMenuState.loaded(
              tribe: tribe!,
            ),
          );
        },
      );
    } on FirebaseException catch (e) {
      emit(
        ContextMenuState.error(
          BaseApiError<FirebaseErrorReason>(
            reason: FirebaseErrorReasonMapper.mapFirebaseError(e),
          ),
        ),
      );
    } catch (e) {
      emit(
        const ContextMenuState.error(
          BaseApiError<FirebaseErrorReason>(
            reason: FirebaseErrorReason.unknownError,
          ),
        ),
      );
    }
  }
}
