import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/models/supported_languages.dart';
import 'package:online_tribes/features/onboarding/data/models/onboarding_content.dart';

import 'package:online_tribes/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetUserOnboardingContentUseCase {
  final OnboardingRepository repository;

  GetUserOnboardingContentUseCase(this.repository);

  Future<Either<BaseApiError, List<OnboardingScreenContent>>> call(
    Language currantLanguage,
  ) {
    return repository.getUserOnboardingScreenContent(currantLanguage);
  }
}
