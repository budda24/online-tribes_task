import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:online_tribes/core/models/supported_languages.dart';

part 'onboarding_event.freezed.dart';

@freezed
class OnboardingEvent with _$OnboardingEvent {
  const factory OnboardingEvent.initializeUserOnboarding(
    Language currantLanguage,
  ) = _InitializeUserOnboarding;
  const factory OnboardingEvent.initializeTribeOnboarding(
    Language currantLanguage,
  ) = _InitializeTribeOnboarding;
}
