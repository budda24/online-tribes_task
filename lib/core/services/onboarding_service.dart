import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/core/services/hive_storage_service.dart';

class OnboardingService {
  final HiveStorageService _hiveStorageService;

  OnboardingService({required HiveStorageService hiveStorageService})
      : _hiveStorageService = hiveStorageService;

  Future<bool> isOnboardingComplete(HiveKeys onboardingKey) async {
    return await _hiveStorageService.get(
          HiveBoxType.initialization,
          onboardingKey.name,
        ) as bool? ??
        false;
  }

  Future<void> completeOnboarding(HiveKeys onboardingKey) async {
    return _hiveStorageService.put(
      HiveBoxType.initialization,
      onboardingKey.name,
      true,
    );
  }

  /// This allows the onboarding process to be redone or reinitialized.
  Future<void> resetOnboarding(HiveKeys onboardingKey) async {
    return _hiveStorageService.put(
      HiveBoxType.initialization,
      onboardingKey.name,
      false,
    );
  }
}
