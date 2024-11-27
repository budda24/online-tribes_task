import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/assets_service.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/core/services/config_service.dart';
import 'package:online_tribes/core/services/data_populating_service.dart';
import 'package:online_tribes/core/services/date_conversion_service.dart';
import 'package:online_tribes/core/services/encryption_service.dart';
import 'package:online_tribes/core/services/github_content_service.dart';
import 'package:online_tribes/core/services/google_auth_service.dart';
import 'package:online_tribes/core/services/hive_storage_service.dart';
import 'package:online_tribes/core/services/onboarding_service.dart';
import 'package:online_tribes/core/services/permission_service.dart';
import 'package:online_tribes/core/services/rate_limiting_service.dart';
import 'package:online_tribes/core/services/shared_preferences_service.dart';
import 'package:online_tribes/core/services/storage_service.dart';
import 'package:online_tribes/core/services/tribe_search_service.dart';
import 'package:online_tribes/core/services/type_ahead_data_collector.dart';
import 'package:online_tribes/core/services/type_ahead_service.dart';
import 'package:online_tribes/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_repository.dart';
import 'package:online_tribes/features/authentication/domain/repositories/auth_service.dart';
import 'package:online_tribes/features/authentication/domain/usecases/fetch_terms_use_case.dart';
import 'package:online_tribes/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:online_tribes/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:online_tribes/features/main_drawer/presentation/bloc/drawer_cubit.dart';
import 'package:online_tribes/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:online_tribes/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/check_onboarding_complete_usecase.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/get_tribe_onboarding_content_usecase.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/get_user_onboarding_content_usecase.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_membership_repository.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';
import 'package:online_tribes/features/shared/repositories/tribe/domain/usecases/create_tribe_usecase.dart';
import 'package:online_tribes/features/shared/repositories/tribe/domain/usecases/is_tribe_name_taken_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/get_user_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/is_user_name_taken_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/save_user_usecase.dart';
import 'package:online_tribes/features/shared/repositories/user/domain/usecases/update_user_usecase.dart';
import 'package:online_tribes/features/shared/usecases/upload_file_usecase.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/attach_tribe_it_to_search_elements_usecase.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/get_tribe_usecase.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/update_tribe_usecase.dart';
import 'package:online_tribes/features/tribe_search/data/tribe_search_repository.dart';
import 'package:online_tribes/router/app_routes.dart';
import 'package:online_tribes/theme/app_colors.dart';
import 'package:online_tribes/theme/app_text_style.dart';

final getIt = GetIt.instance;

//
// Core Module
//
@module
abstract class CoreModule {
  @lazySingleton
  LoggerService get logger => LoggerService();

  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
}

//
// Authentication Module
//
@module
abstract class AuthModule {
  @lazySingleton
  AuthRepository authRepository(AuthRepositoryImpl impl) => impl;

  @lazySingleton
  IAuthService get iAuthService => FirebaseAuthService(getIt<FirebaseAuth>());

  @lazySingleton
  SignInWithGoogleUseCase get signInWithGoogleUseCase =>
      SignInWithGoogleUseCase(getIt<AuthRepository>());

  @lazySingleton
  SignOutUseCase get signOutUseCase => SignOutUseCase(getIt<AuthRepository>());
}

//
// User Management Module
//
@module
abstract class UserModule {
  @lazySingleton
  UserRepository get userRepository => UserRepositoryImpl(
        firestore: getIt<FirebaseFirestore>(),
        logger: getIt<LoggerService>(),
      );

  @lazySingleton
  GetUserUseCase get getUserUseCase => GetUserUseCase(
        userRepository: getIt<UserRepository>(),
      );

  @lazySingleton
  SaveUserUseCase get saveUserUseCase =>
      SaveUserUseCase(userRepository: getIt<UserRepository>());

  @lazySingleton
  UpdateUserUseCase get updateUserUseCase =>
      UpdateUserUseCase(userRepository: getIt<UserRepository>());
  @lazySingleton
  IsUserNameTakenUseCase get isUserNameTakenUseCase =>
      IsUserNameTakenUseCase(userRepository: getIt<UserRepository>());
}

//
// Tribe Management Module
//
@module
abstract class TribeModule {
  @lazySingleton
  TribeRepository get tribeRepository => TribeRepositoryImpl(
        firestore: getIt<FirebaseFirestore>(),
        logger: getIt<LoggerService>(),
      );
  @lazySingleton
  TribeMembershipRepository get tribeMembershipRepository =>
      TribeMembershipRepositoryImpl(
        firestore: getIt<FirebaseFirestore>(),
        logger: getIt<LoggerService>(),
      );
  @lazySingleton
  GetLastRegisteredTribeUseCase get getLastRegisteredTribeUseCase =>
      GetLastRegisteredTribeUseCase(getIt<TribeRepository>());
  @lazySingleton
  IsTribeNameTakenUseCase get isTribeNameTakenUseCase =>
      IsTribeNameTakenUseCase(getIt<TribeRepository>());
  @lazySingleton
  CreateTribeUseCase get createTribeUseCase => CreateTribeUseCase(
        getIt<TribeRepository>(),
      );
  @lazySingleton
  UpdateTribeUseCase get updateTribeUseCase => UpdateTribeUseCase(
        getIt<TribeRepository>(),
      );

  @lazySingleton
  GetTribeOnboardingContentUseCase get getTribeOnboardingContentUseCase =>
      GetTribeOnboardingContentUseCase(
        getIt<OnboardingRepository>(),
      );

  @lazySingleton
  AttachTribeToSearchElementsUseCase get attachTribeToSearchElementsUseCase =>
      AttachTribeToSearchElementsUseCase(
        getIt<TribeRepository>(),
      );
}

//
// Tribe Search Module
//
@module
abstract class TribeSearchModule {
  @lazySingleton
  TypeAheadSearchDataCollector get typeAheadSearchDataCollector =>
      TypeAheadSearchDataCollector(getIt<FirebaseFirestore>());

  @lazySingleton
  TribeSearchService get tribeSearchService => TribeSearchService(
        getIt<FirebaseFirestore>(),
        getIt<LoggerService>(),
      );

  @lazySingleton
  TribeSearchRepository get tribeSearchRepository => TribeSearchRepository(
        logger: getIt<LoggerService>(),
        searchDataCollector: getIt<TypeAheadSearchDataCollector>(),
        tribeSearchService: getIt<TribeSearchService>(),
      );
}

//
// Onboarding Module
//
@module
abstract class OnboardingModule {
  @lazySingleton
  OnboardingRepository get onboardingRepository => OnboardingRepositoryImpl(
        getIt<GithubContentService>(),
      );

  @lazySingleton
  CheckOnboardingCompleteUseCase get checkOnboardingCompleteUseCase =>
      CheckOnboardingCompleteUseCase(getIt<OnboardingService>());

  @lazySingleton
  CompleteOnboardingUseCase get completeOnboardingUseCase =>
      CompleteOnboardingUseCase(getIt<OnboardingService>());

  @lazySingleton
  GetUserOnboardingContentUseCase get getOnboardingContentUseCase =>
      GetUserOnboardingContentUseCase(getIt<OnboardingRepository>());

  @lazySingleton
  OnboardingService get onboardingService =>
      OnboardingService(hiveStorageService: getIt<HiveStorageService>());
}

//
// Storage Module
//
@module
abstract class StorageModule {
  @lazySingleton
  IStorageService get storageService => FirebaseStorageService();

  @lazySingleton
  HiveStorageService get localStorageService => HiveStorageService(Hive);

  @lazySingleton
  SharedPreferencesService get sharedPreferencesService =>
      SharedPreferencesService();
  @lazySingleton
  UploadFileUseCase get uploadFileUseCase => UploadFileUseCase(
        logger: getIt<LoggerService>(),
        storageService: getIt<IStorageService>(),
      );

  @lazySingleton
  EncryptionService get encryptionService => EncryptionService(
        const FlutterSecureStorage(),
        Hive,
      );
}

//
// Consent & Permissions Module
//
@module
abstract class ConsentPermissionModule {
/*   @lazySingleton
  ConsentService get consentService => ConsentService();
 */
  @lazySingleton
  PermissionService get permissionService => PermissionService();
}

//
// Github Content Module
//
@module
abstract class GithubContentModule {
  @lazySingleton
  GithubContentService get githubContentService =>
      GithubContentService(getIt<Dio>());

  @lazySingleton
  FetchTermsUseCase get fetchTermsUseCase =>
      FetchTermsUseCase(getIt<GithubContentService>());
}

//
// Miscellaneous Services Module
//
@module
abstract class MiscServicesModule {
  @lazySingleton
  BannerService get bannerService => BannerService();

  @lazySingleton
  ConfigService get configService => ConfigService(
        getIt<FirebaseFirestore>(),
        getIt<LoggerService>(),
      );

  @lazySingleton
  RateLimitingService get rateLimitingService =>
      RateLimitingService(getIt<FirebaseFirestore>());
  @lazySingleton
  GoogleAuthService get googleAuthService => GoogleAuthService();

  @lazySingleton
  DataPopulatingService get dataPopulatingService =>
      DataPopulatingService(getIt<FirebaseFirestore>());

  @lazySingleton
  TypeAheadService get typeAheadService =>
      TypeAheadService(getIt<FirebaseFirestore>());

  @lazySingleton
  AssetService get assetService => AssetService();
  @lazySingleton
  DateConversionService get dateConversionService => DateConversionService();
  @lazySingleton
  AppColors get appColors => AppColors.defaultColors();
  @lazySingleton
  AppTextStyles get appTextStyles => AppTextStyles.defaultStyles();
  @lazySingleton
  StyledDrawerCubit styledDrawerCubit(
    UserRepository userRepository,
    TribeRepository tribeRepository,
  ) =>
      StyledDrawerCubit(
        userRepository: userRepository,
        tribeRepository: tribeRepository,
      );
}

//
// Routing Module
//
@module
abstract class RoutingModule {
  @injectable
  GoRouter get goRouter => GoRouter(
        routes: $appRoutes,
        observers: [],
      );
}
