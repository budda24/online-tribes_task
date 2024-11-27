import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/configure_dependencies.config.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/fake_translation.dart';
import 'package:online_tribes/features/main_drawer/presentation/bloc/drawer_cubit.dart';
import 'package:online_tribes/features/main_drawer/presentation/bloc/drawer_state.dart';
import 'package:online_tribes/features/shared/models/visitor_types.dart';
import 'package:online_tribes/features/shared/repositories/tribe/data/repositories/tribe_repository.dart';
import 'package:online_tribes/features/shared/repositories/user/data/repositories/user_repository.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:online_tribes/router/app_routes.dart';
import 'package:shimmer/shimmer.dart';

class StyledDrawer extends StatelessWidget {
  Widget _buildShimmerTile(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.appColors.shimmerBaseColor,
      highlightColor: context.appColors.shimmerBaseColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.appColors.shimmerBaseColor,
          radius: 24,
        ),
        title: Container(
          height: 16,
          width: double.infinity,
          color: context.appColors.shimmerBaseColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StyledDrawerCubit(
        userRepository: getIt<UserRepository>(),
        tribeRepository: getIt<TribeRepository>(),
      )..loadUserData(),
      child: Drawer(
        child: BlocConsumer<StyledDrawerCubit, StyledDrawerState>(
          listener: (context, state) {
            state.mapOrNull(
              error: (state) {
                context
                  ..popRoute()
                  ..showErrorBanner(
                    ErrorUtility.getErrorMessage(context, state.error),
                  );
              },
            );
          },
          builder: (context, state) {
            return state.map(
              initial: (_) => const SizedBox.shrink(),
              loading: (_) => ListView(
                children: [
                  _buildShimmerTile(context),
                  _buildShimmerTile(context),
                ],
              ),
              loaded: (state) => SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          fakeTranslation('Switch tribes'),
                          style: context.appTextStyles.subtitle2BOld,
                        ),
                      ),
                    ),
                    Divider(
                      color: context.appColors.textColor.withOpacity(0.5),
                    ),
                    ListTile(
                      onTap: () {
                        context.router.pop();
                        TribeSearchRoute().go(context);
                      },
                      leading: Assets.shared.drawer.discoverTribe.svg(
                        width: 42.w,
                        height: 42.h,
                      ),
                      title: Text(
                        fakeTranslation('Discover tribes'),
                        style: context.appTextStyles.bodyText2,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        context.router.pop();
                        TribeRegistrationRoute().push<void>(context);
                      },
                      leading: Assets.shared.drawer.createTribe.svg(
                        width: 42.w,
                        height: 42.h,
                      ),
                      title: Text(
                        fakeTranslation('Create tribes'),
                        style: context.appTextStyles.bodyText2,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...state.userTribes.map(
                              (tribe) {
                                return ListTile(
                                  onTap: () => HomePageRoute(),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(tribe.signUrl!),
                                  ),
                                  title: Text(
                                    tribe.name,
                                    style: context.appTextStyles.bodyText2,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: context.appColors.textColor.withOpacity(0.5),
                    ),
                    ListTile(
                      onTap: () => UserProfileRoute(
                        userId: state.userId,
                        visitorType: VisitorType.owner,
                      ).go(context),
                      leading: state.profilePictureUrl != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(state.profilePictureUrl ?? ''),
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  Assets.shared.logo.logoSquer.image().image,
                            ),
                      title: Text(
                        fakeTranslation('My profile'),
                        style: context.appTextStyles.bodyText2,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Stack(
                        children: [
                          Assets.shared.drawer.joinRequest.svg(
                            width: 42.w,
                            height: 42.h,
                          ),
                          Positioned(
                            right: 0,
                            top: 22,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              // TODO(sadji): Fix this
                              child: Text(
                                '1',
                                style: context.appTextStyles.bodyText2.copyWith(
                                  color:
                                      context.appColors.scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        fakeTranslation('User join request'),
                        style: context.appTextStyles.bodyText2,
                      ),
                    ),
                    32.verticalSpace,
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        Icons.thumb_up_alt_outlined,
                        size: 24,
                        color: context.appColors.disabledColor,
                      ),
                      title: Text(
                        fakeTranslation('Feedback'),
                        style: context.appTextStyles.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              error: (value) {
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
