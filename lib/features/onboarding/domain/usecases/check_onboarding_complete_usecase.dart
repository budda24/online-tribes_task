import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/core/services/onboarding_service.dart';

class CheckOnboardingCompleteUseCase {
  final OnboardingService _onboardingService;

  CheckOnboardingCompleteUseCase(this._onboardingService);

  Future<bool> call(HiveKeys storageKey) {
    return _onboardingService.isOnboardingComplete(storageKey);
  }
}
