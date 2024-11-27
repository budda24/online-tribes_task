import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_bloc.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_event.dart';
import 'package:online_tribes/features/onboarding/presentation/bloc/bloc/onboarding_state.dart';
import 'package:online_tribes/features/onboarding/presentation/widgets/error_onboarding_content.dart';
import 'package:online_tribes/features/onboarding/presentation/widgets/loading_onboarding_content.dart';
import 'package:online_tribes/features/onboarding/presentation/widgets/success_onbording_content.dart';

class OnboardingPage extends StatefulWidget {
  final OnboardingEvent initialOnboardingEvent;

  const OnboardingPage({required this.initialOnboardingEvent, super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void didChangeDependencies() {
    context.read<OnboardingBloc>().add(widget.initialOnboardingEvent);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            state.maybeWhen(
              error: (error) {
                getIt<BannerService>().showErrorBanner(
                  message: ErrorUtility.getErrorMessage(context, error),
                  context: context,
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.map(
              initial: (_) => LoadingOnboardingContent(),
              loading: (_) => LoadingOnboardingContent(),
              error: (_) => ErrorOnboardingContent(),
              githubContentReady: (value) => SuccessOnboardingContent(
                onboardingScreenContent: value.onboardingScreenContent,
              ),
            );
          },
        ),
      ),
    );
  }
}
