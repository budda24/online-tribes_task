import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:online_tribes/features/onboarding/presentation/widgets/onboarding_body.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';

class LoadingOnboardingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final page = PageViewModel(
      title: '',
      image: const Center(
        child: StyledLoadingIndicatorWidget(),
      ),
      bodyWidget: const SizedBox.shrink(),
    );

    return OnboardingBody(
      pages: [page],
      isError: true,
    );
  }
}
