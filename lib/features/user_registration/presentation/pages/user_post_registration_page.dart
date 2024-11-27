import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/core/services/onboarding_service.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_filled_button.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_outline_button.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';
import 'package:online_tribes/features/user_registration/data/user_registration_error_utility.dart';
import 'package:online_tribes/features/user_registration/presentation/bloc/bloc/user_registration_cubit.dart';
import 'package:online_tribes/features/user_registration/presentation/bloc/bloc/user_registration_state.dart';
import 'package:online_tribes/features/user_registration/presentation/widgets/main_picture.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:online_tribes/router/app_routes.dart';

class UserPostRegisterPage extends StatefulWidget {
  final String userId;
  final String userPictureUrl;

  const UserPostRegisterPage({
    required this.userId,
    required this.userPictureUrl,
  });

  @override
  State<UserPostRegisterPage> createState() => _UserPostRegisterPageState();
}

class _UserPostRegisterPageState extends State<UserPostRegisterPage> {
  Future<void> _handleCreateTribePressed(
    BuildContext context,
  ) async {
    await context.read<UserRegistrationCubit>().saveRegistrationFinished();

    final onboardingComplete = await getIt<OnboardingService>()
        .isOnboardingComplete(HiveKeys.isTribeOnboardingComplete);

    if (!onboardingComplete) {
      if (!context.mounted) return;
      await TribeOnboardingRoute().push<void>(context);
      return;
    } else {
      if (!context.mounted) return;
      TribeRegistrationRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserRegistrationCubit, UserRegistrationState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          failure: (value) {
            // Handle failure and show error banner
            getIt<BannerService>().showErrorBanner(
              message: RegistrationErrorUtility.getAuthErrorMessage(
                context,
                value.error,
              ),
              context: context,
            );
          },
        );
      },
      builder: (context, state) {
        return state.maybeMap(
          orElse: () {
            return Scaffold(
              body: SafeArea(
                child: ColoredBox(
                  color: context.appColors.backgroundColor,
                  child: Column(
                    children: [
                      StyledMainPadding(
                        child: SizedBox(
                          height: 499.h,
                          child: Column(
                            children: [
                              Text(
                                context.localizations.congratulation,
                                style: context.appTextStyles.headline1,
                              ),
                              Text(
                                context.localizations.youHaveBecomePartOf,
                                style: context.appTextStyles.subtitle1
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                context.localizations.onlineTribes,
                                style: context.appTextStyles.subtitle1.copyWith(
                                  color: context.appColors.primaryColor,
                                ),
                              ),
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.w,
                                      ),
                                      child: Assets
                                          .registration.postRegistrationWall
                                          .image(
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    MainPicture.user(
                                      url: widget.userPictureUrl,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                context.localizations.nowItIsTimeTo,
                                style: context.appTextStyles.bodyText2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 2.h,
                            ),
                            child: StyledFilledButton(
                              leadingIcon: Icons.search,
                              onPressed: () => TribeSearchRoute().go(context),
                              buttonText: context.localizations.searchTribe,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 16.h,
                            ),
                            child: StyledOutlineButton(
                              onPressed: () =>
                                  _handleCreateTribePressed(context),
                              buttonText: context.localizations.createTribe,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: (value) {
            return const Scaffold(
              body: Center(child: StyledLoadingIndicatorWidget()),
            );
          },
        );
      },
    );
  }
}
