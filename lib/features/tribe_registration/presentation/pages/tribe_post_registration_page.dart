import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/models/hive_box_enums.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/core/services/onboarding_service.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/tribe_registration_error_utility.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_filled_button.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';
import 'package:online_tribes/features/tribe_registration/presentation/bloc/bloc/tribe_registration_cubit.dart';
import 'package:online_tribes/features/tribe_registration/presentation/bloc/bloc/tribe_registration_state.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:online_tribes/router/app_routes.dart';

class TribePostRegistrationPage extends StatelessWidget {
  final String tribeName;

  const TribePostRegistrationPage({required this.tribeName, super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TribeRegistrationCubit, TribeRegistrationState>(
      listener: (context, state) {
        state.mapOrNull(
          failure: (value) {
            // Handle failure and show error banner
            getIt<BannerService>().showErrorBanner(
              message: TribeRegistrationErrorUtility.getErrorMessage(
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
                  child: StyledMainPadding(
                    customPadding:
                        EdgeInsets.symmetric(horizontal: 20.w).copyWith(
                      top: 66.h,
                      bottom: 64.w,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Congratulation',
                          style: context.appTextStyles.headline1,
                        ),
                        30.verticalSpace,
                        Text(
                          'You have made first step to create ',
                          style: context.appTextStyles.subtitle1
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          tribeName,
                          style: context.appTextStyles.subtitle1
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Expanded(
                          child: Center(
                            child:
                                Assets.registration.postTribeRegistration.image(
                              width: 170.w,
                              height: 230.h,
                              fit: BoxFit.cover,
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
                                onPressed: () async {
                                  await context
                                      .read<TribeRegistrationCubit>()
                                      .saveRegistrationFinish();
                                  await getIt<OnboardingService>()
                                      .resetOnboarding(
                                    HiveKeys.isTribeOnboardingComplete,
                                  );
                                  if (!context.mounted) return;
                                  HomePageRoute().go(context);
                                },
                                buttonText: 'See tribe',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          loading: (value) => const StyledLoadingIndicatorWidget(),
        );
      },
    );
  }
}
