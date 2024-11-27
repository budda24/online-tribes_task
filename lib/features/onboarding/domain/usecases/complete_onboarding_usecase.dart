import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/core/services/onboarding_service.dart';

class CompleteOnboardingUseCase {
  final OnboardingService _onboardingService;

  CompleteOnboardingUseCase(this._onboardingService);

  Future<void> call(HiveKeys storageKey) {
    return _onboardingService.completeOnboarding(storageKey);
  }
}
