import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/injection.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/authentication/presentation/bloc/bloc/auth_bloc.dart';
import 'package:online_tribes/features/authentication/presentation/bloc/bloc/auth_event.dart';
import 'package:online_tribes/features/authentication/presentation/bloc/bloc/auth_state.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';

import 'package:online_tribes/features/shared/widgets/images/styled_logo_circular.dart';
import 'package:online_tribes/features/user_registration/domain/entities/user_registration_step_enum.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:online_tribes/router/app_routes.dart';

import 'package:sign_in_button/sign_in_button.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ColoredBox(
          color: context.appColors.backgroundColor,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              state.mapOrNull(
                signedUpWithGoogle: (state) => AcceptTermsRoute().go(context),
                loggedInWithGoogle: (state) async {
                  if ((state.user.lastRegistrationStepIndex) <=
                      UserRegistrationStep.hobbies.index) {
                    await UserRegistrationRoute().push<void>(context);
                  } else if (state.user.lastRegistrationStepIndex ==
                      UserRegistrationStep.postRegistration.index) {
                    PostUserRegisterRoute(
                      userId: state.user.userId ?? '',
                      userPictureUrl:
                          state.user.information?.profilePictureUrl ?? '',
                    ).go(context);
                  } else {
                    TribeSearchRoute().go(context);
                  }
                },
                failure: (state) => getIt<BannerService>().showErrorBanner(
                  context: context,
                  message: ErrorUtility.getErrorMessage(context, state.error),
                ),
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                loading: () =>
                    const Center(child: StyledLoadingIndicatorWidget()),
                orElse: () => SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white,
                                  Colors.transparent,
                                  Colors.white,
                                  Colors.transparent,
                                ],
                                stops: [
                                  0.0,
                                  0.0,
                                  0.4,
                                  1.0,
                                ], // Adjust this to control where the fade starts
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Assets.authetication.poitratWall.image(
                              width: 1.sw,
                              height: 0.6.sh,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned.fill(
                            top: 0.20.sh,
                            child: Column(
                              children: [
                                const StyledLogoCircular(
                                  size: 125,
                                ),
                                25.verticalSpace,
                                Text(
                                  context.localizations.preAuthTitle,
                                  style: context.appTextStyles.headline1,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  context.localizations.preAuthTitleSubtitle,
                                  style: context.appTextStyles.subtitle1,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      117.verticalSpace,
                      SignInButton(
                        Buttons.google,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50.w,
                          vertical: 10.h,
                        ),
                        onPressed: () => context
                            .read<AuthBloc>()
                            .add(const AuthEvent.googleSignInRequested()),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
