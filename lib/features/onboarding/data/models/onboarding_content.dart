import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_content.freezed.dart';
part 'onboarding_content.g.dart';

@freezed
class OnboardingScreenContent with _$OnboardingScreenContent {
  const factory OnboardingScreenContent({
    required String title,
    required String description,
    required String imageUrl,
  }) = _OnboardingScreenContent;

  factory OnboardingScreenContent.fromJson(Map<String, dynamic> json) =>
      _$OnboardingScreenContentFromJson(json);
}
