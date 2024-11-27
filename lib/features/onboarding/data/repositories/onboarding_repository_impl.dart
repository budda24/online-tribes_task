import 'package:dartz/dartz.dart';
import 'package:online_tribes/core/error/base_api_error.dart';
import 'package:online_tribes/core/models/github_resources_paths.dart';
import 'package:online_tribes/core/models/supported_languages.dart';
import 'package:online_tribes/core/services/github_content_service.dart';
import 'package:online_tribes/features/onboarding/data/models/onboarding_content.dart';
import 'package:online_tribes/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final GithubContentService _githubContentService;

  OnboardingRepositoryImpl(this._githubContentService);

  @override
  Future<Either<BaseApiError<dynamic>, List<OnboardingScreenContent>>>
      getUserOnboardingScreenContent(
    Language currantLanguage,
  ) async {
    final GithubContentPath path;
    switch (currantLanguage) {
      case Language.english:
        path = GithubContentPath.userOnboardingEn();
        break;
      case Language.polish:
        path = GithubContentPath.userOnboardingPl();
        break;
      case Language.ukrainian:
        path = GithubContentPath.userOnboardingUk();
        break;
    }
    final result = await _githubContentService.fetchFileContentJson(
      githubResourcesPaths: path,
    );

    return result.fold(
      Left.new,
      (content) {
        final onboardingScreenContent =
            content.map(OnboardingScreenContent.fromJson).toList();
        return Right(onboardingScreenContent);
      },
    );
  }

  @override
  Future<Either<BaseApiError<dynamic>, List<OnboardingScreenContent>>>
      getTribeOnboardingScreenContent(
    Language currantLanguage,
  ) async {
    final GithubContentPath path;
    switch (currantLanguage) {
      case Language.english:
        path = GithubContentPath.tribeOnboardingEn();
        break;
      case Language.polish:
        path = GithubContentPath.tribeOnboardingPl();
        break;
      case Language.ukrainian:
        path = GithubContentPath.tribeOnboardingUk();
        break;
    }
    final result = await _githubContentService.fetchFileContentJson(
      githubResourcesPaths: path,
    );

    return result.fold(
      Left.new,
      (content) {
        final onboardingScreenContent =
            content.map(OnboardingScreenContent.fromJson).toList();
        return Right(onboardingScreenContent);
      },
    );
  }
}
