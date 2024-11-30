import 'package:bloc/bloc.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/features/main_drawer/presentation/bloc/drawer_state.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/models/tribe_model.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';

class StyledDrawerCubit extends Cubit<StyledDrawerState> {
  final UserRepository _userRepository;
  final TribeRepository _tribeRepository;

  StyledDrawerCubit({
    required UserRepository userRepository,
    required TribeRepository tribeRepository,
  })  : _userRepository = userRepository,
        _tribeRepository = tribeRepository,
        super(const StyledDrawerState.initial());

  Future<void> loadUserData() async {
    final userId = _userRepository.getUserId;

    try {
      emit(const StyledDrawerState.loading());

      final userResult = await _userRepository.getUser(userId);
      final user = userResult.fold<UserModel>(
        (failure) {
          StyledDrawerState.error(failure);
          return UserModel.empty();
        },
        (user) => user,
      );

      final tribeResult = await _tribeRepository.getTribesForUser(userId);
      final tribes = tribeResult.fold<List<TribeModel>>(
        (failure) {
          StyledDrawerState.error(
            BaseApiError(
              reason: failure.toString(),
            ),
          );
          return [];
        },
        (userTribes) {
          LoggerService().logInfo(message: '$userTribes');
          return List.from(userTribes.memberTribes)..addAll(userTribes.ownedTribes);
        },
      );

      emit(
        StyledDrawerState.loaded(
          userId: user.userId!,
          profilePictureUrl: user.information?.profilePictureUrl,
          userTribes: tribes,
        ),
      );
    } catch (e) {
      emit(
        StyledDrawerState.error(
          BaseApiError(
            reason: e.toString(),
          ),
        ),
      );
    }
  }
}
