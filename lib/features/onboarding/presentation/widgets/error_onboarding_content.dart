import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/features/onboarding/presentation/widgets/onboarding_body.dart';
import 'package:online_tribes/gen/assets.gen.dart';

class ErrorOnboardingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final page = PageViewModel(
      title: context.localizations.genericErrorMessage,
      image: Center(
        child: Assets.shared.downloadingError.image(),
      ),
      bodyWidget: const SizedBox.shrink(),
    );

    return OnboardingBody(
      pages: [page],
      isError: true,
    );
  }
}
