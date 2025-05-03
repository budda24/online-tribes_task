// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/authentication/data/repositories/auth_repository_impl.dart'
    as _i317;
import '../../features/authentication/domain/repositories/auth_repository.dart'
    as _i742;
import '../../features/authentication/domain/repositories/auth_service.dart'
    as _i814;
import '../../features/authentication/domain/usecases/fetch_terms_use_case.dart'
    as _i4;
import '../../features/authentication/domain/usecases/sign_in_with_google_usecase.dart'
    as _i981;
import '../../features/authentication/domain/usecases/sign_out_usecase.dart'
    as _i749;
import '../../features/main_drawer/presentation/bloc/drawer_cubit.dart'
    as _i518;
import '../../features/onboarding/domain/repositories/onboarding_repository.dart'
    as _i430;
import '../../features/onboarding/domain/usecases/check_onboarding_complete_usecase.dart'
    as _i413;
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart'
    as _i360;
import '../../features/onboarding/domain/usecases/get_tribe_onboarding_content_usecase.dart'
    as _i484;
import '../../features/onboarding/domain/usecases/get_user_onboarding_content_usecase.dart'
    as _i1055;
import '../../features/shared/repositories/tribe/data/repositories/tribe_membership_repository.dart'
    as _i203;
import '../../features/shared/repositories/tribe/data/repositories/tribe_repository.dart'
    as _i251;
import '../../features/shared/repositories/tribe/domain/usecases/create_tribe_usecase.dart'
    as _i726;
import '../../features/shared/repositories/tribe/domain/usecases/is_tribe_name_taken_usecase.dart'
    as _i954;
import '../../features/shared/repositories/user/data/repositories/user_repository.dart'
    as _i526;
import '../../features/shared/repositories/user/domain/usecases/get_user_usecase.dart'
    as _i540;
import '../../features/shared/repositories/user/domain/usecases/is_user_name_taken_usecase.dart'
    as _i448;
import '../../features/shared/repositories/user/domain/usecases/save_user_usecase.dart'
    as _i193;
import '../../features/shared/repositories/user/domain/usecases/update_user_usecase.dart'
    as _i826;
import '../../features/shared/usecases/upload_file_usecase.dart' as _i449;
import '../../features/tribe_registration/domain/usecases/attach_tribe_it_to_search_elements_usecase.dart'
    as _i789;
import '../../features/tribe_registration/domain/usecases/get_tribe_usecase.dart'
    as _i100;
import '../../features/tribe_registration/domain/usecases/update_tribe_usecase.dart'
    as _i944;
import '../../features/tribe_search/data/tribe_search_repository.dart' as _i20;
import '../../theme/app_colors.dart' as _i189;
import '../../theme/app_text_style.dart' as _i679;
import '../logging/logger_service.dart' as _i731;
import '../services/assets_service.dart' as _i752;
import '../services/banner_service.dart' as _i156;
import '../services/config_service.dart' as _i216;
import '../services/data_populating_service.dart' as _i1022;
import '../services/date_conversion_service.dart' as _i757;
import '../services/encryption_service.dart' as _i180;
import '../services/github_content_service.dart' as _i1042;
import '../services/google_auth_service.dart' as _i947;
import '../services/hive_storage_service.dart' as _i833;
import '../services/onboarding_service.dart' as _i854;
import '../services/permission_service.dart' as _i165;
import '../services/rate_limiting_service.dart' as _i405;
import '../services/shared_preferences_service.dart' as _i29;
import '../services/storage_service.dart' as _i306;
import '../services/tribe_search_service.dart' as _i491;
import '../services/type_ahead_data_collector.dart' as _i406;
import '../services/type_ahead_service.dart' as _i677;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final routingModule = _$RoutingModule();
    final coreModule = _$CoreModule();
    final authModule = _$AuthModule();
    final userModule = _$UserModule();
    final tribeModule = _$TribeModule();
    final tribeSearchModule = _$TribeSearchModule();
    final onboardingModule = _$OnboardingModule();
    final storageModule = _$StorageModule();
    final consentPermissionModule = _$ConsentPermissionModule();
    final githubContentModule = _$GithubContentModule();
    final miscServicesModule = _$MiscServicesModule();
    gh.factory<_i583.GoRouter>(() => routingModule.goRouter);
    gh.lazySingleton<_i731.LoggerService>(() => coreModule.logger);
    gh.lazySingleton<_i361.Dio>(() => coreModule.dio);
    gh.lazySingleton<_i59.FirebaseAuth>(() => coreModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => coreModule.firestore);
    gh.lazySingleton<_i814.IAuthService>(() => authModule.iAuthService);
    gh.lazySingleton<_i981.SignInWithGoogleUseCase>(
        () => authModule.signInWithGoogleUseCase);
    gh.lazySingleton<_i749.SignOutUseCase>(() => authModule.signOutUseCase);
    gh.lazySingleton<_i526.UserRepository>(() => userModule.userRepository);
    gh.lazySingleton<_i540.GetUserUseCase>(() => userModule.getUserUseCase);
    gh.lazySingleton<_i193.SaveUserUseCase>(() => userModule.saveUserUseCase);
    gh.lazySingleton<_i826.UpdateUserUseCase>(
        () => userModule.updateUserUseCase);
    gh.lazySingleton<_i448.IsUserNameTakenUseCase>(
        () => userModule.isUserNameTakenUseCase);
    gh.lazySingleton<_i251.TribeRepository>(() => tribeModule.tribeRepository);
    gh.lazySingleton<_i203.TribeMembershipRepository>(
        () => tribeModule.tribeMembershipRepository);
    gh.lazySingleton<_i100.GetLastRegisteredTribeUseCase>(
        () => tribeModule.getLastRegisteredTribeUseCase);
    gh.lazySingleton<_i954.IsTribeNameTakenUseCase>(
        () => tribeModule.isTribeNameTakenUseCase);
    gh.lazySingleton<_i726.CreateTribeUseCase>(
        () => tribeModule.createTribeUseCase);
    gh.lazySingleton<_i944.UpdateTribeUseCase>(
        () => tribeModule.updateTribeUseCase);
    gh.lazySingleton<_i484.GetTribeOnboardingContentUseCase>(
        () => tribeModule.getTribeOnboardingContentUseCase);
    gh.lazySingleton<_i789.AttachTribeToSearchElementsUseCase>(
        () => tribeModule.attachTribeToSearchElementsUseCase);
    gh.lazySingleton<_i406.TypeAheadSearchDataCollector>(
        () => tribeSearchModule.typeAheadSearchDataCollector);
    gh.lazySingleton<_i491.TribeSearchService>(
        () => tribeSearchModule.tribeSearchService);
    gh.lazySingleton<_i20.TribeSearchRepository>(
        () => tribeSearchModule.tribeSearchRepository);
    gh.lazySingleton<_i430.OnboardingRepository>(
        () => onboardingModule.onboardingRepository);
    gh.lazySingleton<_i413.CheckOnboardingCompleteUseCase>(
        () => onboardingModule.checkOnboardingCompleteUseCase);
    gh.lazySingleton<_i360.CompleteOnboardingUseCase>(
        () => onboardingModule.completeOnboardingUseCase);
    gh.lazySingleton<_i1055.GetUserOnboardingContentUseCase>(
        () => onboardingModule.getOnboardingContentUseCase);
    gh.lazySingleton<_i854.OnboardingService>(
        () => onboardingModule.onboardingService);
    gh.lazySingleton<_i306.IStorageService>(() => storageModule.storageService);
    gh.lazySingleton<_i833.HiveStorageService>(
        () => storageModule.localStorageService);
    gh.lazySingleton<_i29.SharedPreferencesService>(
        () => storageModule.sharedPreferencesService);
    gh.lazySingleton<_i449.UploadFileUseCase>(
        () => storageModule.uploadFileUseCase);
    gh.lazySingleton<_i180.EncryptionService>(
        () => storageModule.encryptionService);
    gh.lazySingleton<_i165.PermissionService>(
        () => consentPermissionModule.permissionService);
    gh.lazySingleton<_i1042.GithubContentService>(
        () => githubContentModule.githubContentService);
    gh.lazySingleton<_i4.FetchTermsUseCase>(
        () => githubContentModule.fetchTermsUseCase);
    gh.lazySingleton<_i156.BannerService>(
        () => miscServicesModule.bannerService);
    gh.lazySingleton<_i216.ConfigService>(
        () => miscServicesModule.configService);
    gh.lazySingleton<_i405.RateLimitingService>(
        () => miscServicesModule.rateLimitingService);
    gh.lazySingleton<_i947.GoogleAuthService>(
        () => miscServicesModule.googleAuthService);
    gh.lazySingleton<_i1022.DataPopulatingService>(
        () => miscServicesModule.dataPopulatingService);
    gh.lazySingleton<_i677.TypeAheadService>(
        () => miscServicesModule.typeAheadService);
    gh.lazySingleton<_i752.AssetService>(() => miscServicesModule.assetService);
    gh.lazySingleton<_i757.DateConversionService>(
        () => miscServicesModule.dateConversionService);
    gh.lazySingleton<_i189.AppColors>(() => miscServicesModule.appColors);
    gh.lazySingleton<_i679.AppTextStyles>(
        () => miscServicesModule.appTextStyles);
    gh.factory<_i317.AuthRepositoryImpl>(() => _i317.AuthRepositoryImpl(
          gh<_i814.IAuthService>(),
          gh<_i974.FirebaseFirestore>(),
          gh<_i731.LoggerService>(),
          gh<_i405.RateLimitingService>(),
          gh<_i193.SaveUserUseCase>(),
          gh<_i540.GetUserUseCase>(),
          gh<_i947.GoogleAuthService>(),
        ));
    gh.lazySingleton<_i742.AuthRepository>(
        () => authModule.authRepository(gh<_i317.AuthRepositoryImpl>()));
    gh.lazySingleton<_i518.StyledDrawerCubit>(
        () => miscServicesModule.styledDrawerCubit(
              gh<_i526.UserRepository>(),
              gh<_i251.TribeRepository>(),
            ));
    return this;
  }
}

class _$RoutingModule extends _i464.RoutingModule {}

class _$CoreModule extends _i464.CoreModule {}

class _$AuthModule extends _i464.AuthModule {}

class _$UserModule extends _i464.UserModule {}

class _$TribeModule extends _i464.TribeModule {}

class _$TribeSearchModule extends _i464.TribeSearchModule {}

class _$OnboardingModule extends _i464.OnboardingModule {}

class _$StorageModule extends _i464.StorageModule {}

class _$ConsentPermissionModule extends _i464.ConsentPermissionModule {}

class _$GithubContentModule extends _i464.GithubContentModule {}

class _$MiscServicesModule extends _i464.MiscServicesModule {}
