import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:online_tribes/features/onboarding/data/models/onboarding_content.dart';
import 'package:online_tribes/features/onboarding/presentation/widgets/onboarding_body.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';

class SuccessOnboardingContent extends StatelessWidget {
  final List<OnboardingScreenContent> onboardingScreenContent;

  const SuccessOnboardingContent({
    required this.onboardingScreenContent,
  });

  @override
  Widget build(BuildContext context) {
    final pages = onboardingScreenContent.map((content) {
      return PageViewModel(
        title: content.title,
        body: content.description,
        image: Center(
          child: CachedNetworkImage(
            imageUrl: content.imageUrl,
            placeholder: (context, url) => const StyledLoadingIndicatorWidget(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    }).toList();

    return OnboardingBody(
      pages: pages,
      isError: false,
    );
  }
}
