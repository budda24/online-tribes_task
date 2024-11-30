import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/logging/logger_service.dart';
import 'package:online_tribes/core/services/config_service.dart';
import 'package:online_tribes/core/services/storage_service.dart';
import 'package:online_tribes/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:online_tribes/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'package:online_tribes/features/authentication/presentation/bloc/bloc/auth_bloc.dart';
import 'package:online_tribes/features/authentication/presentation/pages/accept_terms_page.dart';
import 'package:online_tribes/features/authentication/presentation/pages/pre_auth_page.dart';
import 'package:online_tribes/features/context_menu/presentation/cubit/context_menu_cubit.dart';
import 'package:online_tribes/features/context_menu/presentation/pages/context_menu_page.dart';
import 'package:online_tribes/features/home/presentation/cubit/home_page_cubit.dart';
import 'package:online_tribes/features/home/presentation/pages/home_page.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/get_tribe_onboarding_content_usecase.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/get_user_onboarding_content_usecase.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_bloc.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_event.dart';
import 'package:online_tribes/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:online_tribes/features/shared/models/visitor_types.dart';
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
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_cubit.dart';
import 'package:online_tribes/features/tribe_profile/presentation/page/tribe_membership_tickets_page.dart';
import 'package:online_tribes/features/tribe_profile/presentation/page/tribe_profile_page.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/attach_tribe_it_to_search_elements_usecase.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/get_tribe_usecase.dart';
import 'package:online_tribes/features/tribe_registration/domain/usecases/update_tribe_usecase.dart';
import 'package:online_tribes/features/tribe_registration/presentation/bloc/bloc/tribe_registration_cubit.dart';
import 'package:online_tribes/features/tribe_registration/presentation/pages/tribe_post_registration_page.dart';
import 'package:online_tribes/features/tribe_registration/presentation/pages/tribe_registration_page.dart';
import 'package:online_tribes/features/tribe_search/data/tribe_search_repository.dart';
import 'package:online_tribes/features/tribe_search/presentation/cubit/tribe_search_cubit.dart';
import 'package:online_tribes/features/tribe_search/presentation/pages/tribe_search_page.dart';
import 'package:online_tribes/features/user_profile/presentation/cubit/user_profile_cubit.dart';
import 'package:online_tribes/features/user_profile/presentation/pages/user_profile_page.dart';
import 'package:online_tribes/features/user_registration/presentation/bloc/bloc/user_registration_cubit.dart';
import 'package:online_tribes/features/user_registration/presentation/pages/user_post_registration_page.dart';
import 'package:online_tribes/features/user_registration/presentation/pages/user_registration_page.dart';

part 'app_routes.g.dart';

class AppRoutes {
  static final routes = [
    const TypedGoRoute<TribeMembershipTicketsRoute>(
      path: '/tribe-membership-tickets',
    ),
    const TypedGoRoute<TribeProfileRoute>(path: '/tribe-profile'),
    const TypedGoRoute<AuthRoute>(path: '/auth'),
    const TypedGoRoute<AcceptTermsRoute>(path: '/accept-terms'),
    const TypedGoRoute<TribeOnboardingRoute>(path: '/user-onboarding'),
    const TypedGoRoute<UserRegistrationRoute>(path: '/user-registration'),
    const TypedGoRoute<PostUserRegisterRoute>(path: '/post-user-register'),
    const TypedGoRoute<UserProfileRoute>(path: '/user-profile'),
    const TypedGoRoute<TribeOnboardingRoute>(path: '/tribe-onboarding'),
    const TypedGoRoute<TribeRegistrationRoute>(path: '/tribe-register'),
    const TypedGoRoute<TribePostRegistrationRoute>(
      path: '/tribe-post-registration',
    ),
    const TypedGoRoute<TribeSearchRoute>(path: '/tribe-search'),
    const TypedGoRoute<HomePageRoute>(path: '/home_page'),
    const TypedGoRoute<ContextMenuRoute>(path: '/context-menu'),
  ];
}

@TypedGoRoute<TribeMembershipTicketsRoute>(
  path: '/tribe-membership-tickets',
)
class TribeMembershipTicketsRoute extends GoRouteData {
  final TribeProfileCubit $extra;

  TribeMembershipTicketsRoute({
    required this.$extra,
  });

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      BlocProvider<TribeProfileCubit>.value(
        value: $extra,
        child: const TribeMembershipTicketsPage(),
      );
}

@TypedGoRoute<TribeProfileRoute>(
  path: '/tribe-profile',
)
class TribeProfileRoute extends GoRouteData {
  final String tribeId;

  TribeProfileRoute({
    required this.tribeId,
  });

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      BlocProvider(
        create: (context) => TribeProfileCubit(
          getIt<TribeRepository>(),
          getIt<TribeMembershipRepository>(),
          getIt<UserRepository>(),
          getIt<ConfigService>(),
        ),
        child: TribeProfilePage(
          tribeId: tribeId,
        ),
      );
}

@TypedGoRoute<UserProfileRoute>(
  path: '/user-profile',
)
class UserProfileRoute extends GoRouteData {
  final VisitorType visitorType;
  final String userId;

  UserProfileRoute({
    required this.visitorType,
    required this.userId,
  });

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      BlocProvider(
        create: (context) => UserProfileCubit(
          userRepository: getIt<UserRepository>(),
          uploadFileUseCase: getIt<UploadFileUseCase>(),
          tribeRepository: getIt<TribeRepository>(),
        ),
        child: UserProfilePage(
          visitorType: visitorType,
          userId: userId,
        ),
      );
}

@TypedGoRoute<UserOnboardingRoute>(
  path: '/user-onboarding',
)
class UserOnboardingRoute extends GoRouteData {
  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      BlocProvider(
        create: (context) => OnboardingBloc(
          getUserOnboardingContentUseCase: getIt<GetUserOnboardingContentUseCase>(),
          getTribeOnboardingContentUseCase: getIt<GetTribeOnboardingContentUseCase>(),
        ),
        child: OnboardingPage(
          initialOnboardingEvent: OnboardingEvent.initializeUserOnboarding(context.currantLanguage),
        ),
      );
}

@TypedGoRoute<AuthRoute>(
  path: '/auth',
)
class AuthRoute extends GoRouteData {
  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      BlocProvider<AuthBloc>(
        create: (_) => AuthBloc(
          signOutUseCase: getIt<SignOutUseCase>(),
          getUserUseCase: getIt<GetUserUseCase>(),
          saveUserUseCase: getIt<SaveUserUseCase>(),
          signInWithGoogleUseCase: getIt<SignInWithGoogleUseCase>(),
          loggerService: getIt<LoggerService>(),
        ),
        child: AuthPage(),
      );
}

@TypedGoRoute<UserRegistrationRoute>(
  path: '/user-registration',
)
class UserRegistrationRoute extends GoRouteData {
  UserRegistrationRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      _buildUserRegistrationCubitProvider(child: const UserRegistrationPage());
}

@TypedGoRoute<PostUserRegisterRoute>(
  path: '/post-user-register',
)
class PostUserRegisterRoute extends GoRouteData {
  final String userId;
  final String userPictureUrl;

  PostUserRegisterRoute({
    required this.userId,
    required this.userPictureUrl,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _buildUserRegistrationCubitProvider(
      child: UserPostRegisterPage(
        userId: userId,
        userPictureUrl: userPictureUrl,
      ),
    );
  }
}

@TypedGoRoute<TribeOnboardingRoute>(
  path: '/tribe-onboarding',
)
class TribeOnboardingRoute extends GoRouteData {
  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      BlocProvider(
        create: (context) => OnboardingBloc(
          getUserOnboardingContentUseCase: getIt<GetUserOnboardingContentUseCase>(),
          getTribeOnboardingContentUseCase: getIt<GetTribeOnboardingContentUseCase>(),
        ),
        child: OnboardingPage(
          initialOnboardingEvent: OnboardingEvent.initializeTribeOnboarding(
            context.currantLanguage,
          ),
        ),
      );
}

@TypedGoRoute<TribeRegistrationRoute>(
  path: '/tribe-register',
)
class TribeRegistrationRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _buildTribeRegistrationCubitProvider(
      child: const TribeRegistrationPage(),
    );
  }
}

@TypedGoRoute<TribePostRegistrationRoute>(
  path: '/tribe-post-registration',
)
class TribePostRegistrationRoute extends GoRouteData {
  final String tribeName;

  TribePostRegistrationRoute({
    required this.tribeName,
  });

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      _buildTribeRegistrationCubitProvider(
        child: TribePostRegistrationPage(
          tribeName: tribeName,
        ),
      );
}

@TypedGoRoute<TribeSearchRoute>(
  path: '/tribe-search',
)
class TribeSearchRoute extends GoRouteData {
  TribeSearchRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      BlocProvider<TribeSearchCubit>(
        create: (context) => TribeSearchCubit(
          getIt<TribeSearchRepository>(),
        ),
        child: const TribeSearchPage(),
      );
}

@TypedGoRoute<AcceptTermsRoute>(
  path: '/accept-terms',
)
class AcceptTermsRoute extends GoRouteData {
  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const AcceptTermsPage();
}

@TypedGoRoute<HomePageRoute>(
  path: '/home_page/:tribeId',
)
class HomePageRoute extends GoRouteData {
  final String tribeId;

  HomePageRoute({required this.tribeId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (context) => HomePageCubit(
        userRepository: getIt<UserRepository>(),
        tribeRepository: getIt<TribeRepository>(),
      ),
      child: HomePage(
        tribeId: tribeId, // Pass the nullable tribeId to the widget
      ),
    );
  }
}

@TypedGoRoute<ContextMenuRoute>(
  path: '/context-menu',
)
class ContextMenuRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return BlocProvider(
      create: (context) => ContextMenuCubit(
        tribeRepository: getIt<TribeRepository>(),
        userRepository: getIt<UserRepository>(),
      ),
      child: const ContextMenuPage(),
    );
  }
}

Widget _buildTribeRegistrationCubitProvider({required Widget child}) {
  return BlocProvider<TribeRegistrationCubit>(
    create: (_) => TribeRegistrationCubit(
      getLastRegisteredTribeUseCase: getIt<GetLastRegisteredTribeUseCase>(),
      createTribeUseCase: getIt<CreateTribeUseCase>(),
      isTribeNameTakenUseCase: getIt<IsTribeNameTakenUseCase>(),
      logger: getIt<LoggerService>(),
      getUserUseCase: getIt<GetUserUseCase>(),
      updateTribeUseCase: getIt<UpdateTribeUseCase>(),
      uploadFileUseCase: getIt<UploadFileUseCase>(),
      firestore: getIt<FirebaseFirestore>(),
      attachTribeToSearchElementsUseCase: getIt<AttachTribeToSearchElementsUseCase>(),
    ),
    child: child,
  );
}

Widget _buildUserRegistrationCubitProvider({required Widget child}) {
  return BlocProvider<UserRegistrationCubit>(
    create: (_) => UserRegistrationCubit(
      storageService: getIt<IStorageService>(),
      updateUserUseCase: getIt<UpdateUserUseCase>(),
      uploadFileUseCase: getIt<UploadFileUseCase>(),
      logger: getIt<LoggerService>(),
      getUserUseCase: getIt<GetUserUseCase>(),
      isUserNameTakenUseCase: getIt<IsUserNameTakenUseCase>(),
    ),
    child: child,
  );
}
