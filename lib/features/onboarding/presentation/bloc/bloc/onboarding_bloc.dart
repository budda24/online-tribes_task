import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/get_tribe_onboarding_content_usecase.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/get_user_onboarding_content_usecase.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_event.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetUserOnboardingContentUseCase _getUserOnboardingContentUseCase;
  final GetTribeOnboardingContentUseCase _getTribeOnboardingContentUseCase;
  OnboardingBloc({
    required GetUserOnboardingContentUseCase getUserOnboardingContentUseCase,
    required GetTribeOnboardingContentUseCase getTribeOnboardingContentUseCase,
  })  : _getUserOnboardingContentUseCase = getUserOnboardingContentUseCase,
        _getTribeOnboardingContentUseCase = getTribeOnboardingContentUseCase,
        super(const OnboardingState.initial()) {
    on<OnboardingEvent>((event, emit) async {
      await event.map(
        initializeUserOnboarding: (state) async {
          emit(const OnboardingState.loading());
          final onboardingScreenContentOrError =
              await _getUserOnboardingContentUseCase
                  .call(state.currantLanguage);

          onboardingScreenContentOrError.fold(
            (error) => emit(OnboardingState.error(error)),
            (onboardingScreenContents) async {
              emit(
                OnboardingState.githubContentReady(
                  HiveKeys.isUserOnboardingComplete,
                  onboardingScreenContents,
                ),
              );
            },
          );
        },
        initializeTribeOnboarding: (state) async {
          emit(const OnboardingState.loading());
          final onboardingScreenContentOrError =
              await _getTribeOnboardingContentUseCase
                  .call(state.currantLanguage);

          onboardingScreenContentOrError.fold(
            (error) => emit(OnboardingState.error(error)),
            (onboardingScreenContents) async {
              emit(
                OnboardingState.githubContentReady(
                  HiveKeys.isTribeOnboardingComplete,
                  onboardingScreenContents,
                ),
              );
            },
          );
        },
      );
    });
  }
}
