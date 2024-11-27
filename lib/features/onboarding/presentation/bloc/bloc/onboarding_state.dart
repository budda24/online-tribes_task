import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/features/onboarding/data/models/onboarding_content.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;
  const factory OnboardingState.loading() = _Loading;
  const factory OnboardingState.error(BaseApiError<dynamic> error) = _Error;
  const factory OnboardingState.githubContentReady(
    HiveKeys storageKey,
    List<OnboardingScreenContent> onboardingScreenContent,
  ) = GithubContentReady;
}
