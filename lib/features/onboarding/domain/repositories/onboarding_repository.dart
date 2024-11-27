import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/models/supported_languages.dart';
import 'package:online_tribes/features/onboarding/data/models/onboarding_content.dart';

abstract class OnboardingRepository {
  Future<Either<BaseApiError, List<OnboardingScreenContent>>>
      getUserOnboardingScreenContent(
    Language currantLanguage,
  );
  Future<Either<BaseApiError, List<OnboardingScreenContent>>>
      getTribeOnboardingScreenContent(
    Language currantLanguage,
  );
}
