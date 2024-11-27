class GithubContentPath {
  final String owner;
  final String repo;
  final String path;
  final String branch;

  // Default constructor
  GithubContentPath({
    required this.owner,
    required this.repo,
    required this.path,
    required this.branch,
  });

  GithubContentPath.userOnboardingEn()
      : owner = 'buddamind',
        repo = 'onboarding_online_tribes',
        path = 'user/v1/user_onboarding_1.0_en.json',
        branch = 'main';
  GithubContentPath.userOnboardingPl()
      : owner = 'buddamind',
        repo = 'onboarding_online_tribes',
        path = 'user/v1/user_onboarding_1.0_pl.json',
        branch = 'main';
  GithubContentPath.userOnboardingUk()
      : owner = 'buddamind',
        repo = 'onboarding_online_tribes',
        path = 'user/v1/user_onboarding_1.0_uk.json',
        branch = 'main';
  GithubContentPath.tribeOnboardingEn()
      : owner = 'buddamind',
        repo = 'onboarding_online_tribes',
        path = 'tribe/v1/tribe_onboarding_1.0_en.json',
        branch = 'main';
  GithubContentPath.tribeOnboardingPl()
      : owner = 'buddamind',
        repo = 'onboarding_online_tribes',
        path = 'tribe/v1/tribe_onboarding_1.0_pl.json',
        branch = 'main';
  GithubContentPath.tribeOnboardingUk()
      : owner = 'buddamind',
        repo = 'onboarding_online_tribes',
        path = 'tribe/v1/tribe_onboarding_1.0_uk.json',
        branch = 'main';
}
