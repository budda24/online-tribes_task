import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_bloc.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_state.dart';
import 'package:online_tribes/router/app_routes.dart';

class OnboardingBody extends StatelessWidget {
  final List<PageViewModel> pages;
  final bool isError;

  const OnboardingBody({
    required this.pages,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: pages,
      onDone: () async {
        if (!context.mounted) return;
        HiveKeys? storageKey;
        if (!isError) {
          await _completeOnboarding(context);
        }

        if (!context.mounted) return;
        storageKey = _getStorageKey(context);

        if (!context.mounted) return;
        _navigateBasedOnKey(context, storageKey);
      },
      next: const SizedBox.shrink(),
      bodyPadding: EdgeInsets.only(top: 150.h),
      done: Text(
        context.localizations.done,
        style: context.appTextStyles.headline4.copyWith(
          color: context.appColors.primaryColor,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: Size(20.w, 10.h),
        activeSize: Size(30.w, 20.h),
        activeColor: context.appColors.primaryColor,
        color: Colors.black26,
        spacing: EdgeInsets.zero,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  // Completes onboarding and retrieves the storage key
  Future<void> _completeOnboarding(BuildContext context) async {
    final state = context.read<OnboardingBloc>().state;
    if (state is GithubContentReady) {
      await getIt<CompleteOnboardingUseCase>().call(state.storageKey);
    }
  }

  // Retrieves the storage key without completing onboarding (in case of error)
  HiveKeys? _getStorageKey(BuildContext context) {
    HiveKeys? storageKey;
    context.read<OnboardingBloc>().state.mapOrNull(
      githubContentReady: (value) {
        storageKey = value.storageKey;
      },
    );
    return storageKey;
  }

  // Navigates based on the storage key
  void _navigateBasedOnKey(BuildContext context, HiveKeys? storageKey) {
    if (context.mounted && storageKey != null) {
      switch (storageKey) {
        case HiveKeys.isTribeOnboardingComplete:
          TribeRegistrationRoute().go(context);
          break;
        case HiveKeys.isUserOnboardingComplete:
          AuthRoute().go(context);
          break;
        // ignore: no_default_cases
        default:
          _showFallbackError(context);
          break;
      }
    } else {
      _showFallbackError(context);
    }
  }

  void _showFallbackError(BuildContext context) {
    getIt<BannerService>().showInfoBanner(
      context: context,
      message: context.localizations.errorOnboarding,
    );
  }
}
