import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/injection.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/shared/models/visitor_types.dart';
import 'package:online_tribes/features/shared/repositories/user/data/models/user_model.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';
import 'package:online_tribes/features/shared/widgets/images/rounded_rectangle_profile_picture.dart';
import 'package:online_tribes/features/shared/widgets/navigation/styled_app_bar.dart';
import 'package:online_tribes/features/shared/widgets/navigation/styled_bottom_navigation_bar.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_profile_picture_picker.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar_view.dart';
import 'package:online_tribes/features/shared/widgets/styled_keyboard_dismiss.dart';
import 'package:online_tribes/features/user_profile/presentation/cubit/user_profile_cubit.dart';
import 'package:online_tribes/features/user_profile/presentation/cubit/user_profile_state.dart';
import 'package:online_tribes/features/user_profile/presentation/widgets/tabs/user_profile_about_tab.dart';
import 'package:online_tribes/features/user_profile/presentation/widgets/tabs/user_profile_activity_tab.dart';
import 'package:online_tribes/features/user_profile/presentation/widgets/tabs/user_profile_post_tab.dart';
import 'package:online_tribes/features/user_profile/presentation/widgets/tabs/user_profile_tribes_tab.dart';

class UserProfilePage extends StatefulWidget {
  final VisitorType visitorType;
  final String userId;

  const UserProfilePage({
    required this.visitorType,
    required this.userId,
    super.key,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  bool isEditing = false;
  File? _profilePicture;
  late final TabController _tabController;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(
      () {
        setState(() {});
      },
    );
    context.read<UserProfileCubit>().getUserData(widget.userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _onProfilePictureChanged(File? file) {
    setState(() {
      _profilePicture = file;
    });
    if (file != null && _user != null) {
      context
          .read<UserProfileCubit>()
          .updateProfilePicture(_profilePicture!, _user!);
    }
  }

  void _onUserUpdated(UserModel updatedUser) {
    context.read<UserProfileCubit>().updateUser(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return StyledKeyboardDismiss(
      child: Scaffold(
        appBar: StyledAppBar.withBackButton(
          title: widget.visitorType == VisitorType.owner
              ? null
              : 'Name of the Tribe',
          actions: widget.visitorType == VisitorType.owner &&
                  _tabController.index == 0
              ? [
                  IconButton(
                    onPressed: _toggleEditing,
                    icon: const Icon(Icons.edit_note_sharp),
                  ),
                ]
              : [],
        ),
        body: BlocConsumer<UserProfileCubit, UserProfileState>(
          listener: (context, state) {
            state.maybeMap(
              orElse: () {},
              error: (state) {
                getIt<BannerService>().showErrorBanner(
                  context: context,
                  message: ErrorUtility.getErrorMessage(context, state.error),
                );
              },
              success: (state) {
                // Clear profile picture locHi file after successful upload
                _profilePicture = null;
                _user = state.user;
              },
            );
          },
          builder: (context, state) {
            return state.maybeMap(
              orElse: () => const Center(child: StyledLoadingIndicatorWidget()),
              loading: (_) =>
                  const Center(child: StyledLoadingIndicatorWidget()),
              success: (state) {
                return SafeArea(
                  child: StyledMainPadding.small(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        if (isEditing)
                          StyledProfilePicturePicker(
                            onImagePicked: _onProfilePictureChanged,
                            initialImageUrl:
                                state.user.information?.profilePictureUrl,
                          )
                        else
                          RoundedRectangleProfilePicture(
                            imageUrl: state.user.information?.profilePictureUrl,
                          ),
                        StyledTabBar(
                          canNavigateTapping: true,
                          tabs: [
                            Tab(
                              text: context.localizations.userProfileTabAbout,
                            ),
                            Tab(
                              text:
                                  context.localizations.userProfileTabActivity,
                            ),
                            Tab(
                              text: context.localizations.userProfileTabTribes,
                            ),
                            Tab(
                              text: context.localizations.userProfileTabPosts,
                            ),
                          ],
                          tabController: _tabController,
                        ),
                        Expanded(
                          child: SizedBox(
                            child: StyledTabBarView(
                              isScrollable: true,
                              tabController: _tabController,
                              tabViews: [
                                UserProfileAboutTab(
                                  isEditing: isEditing,
                                  user: state.user,
                                  onUserUpdated: _onUserUpdated,
                                  profilePicture: _profilePicture,
                                  onProfilePictureChanged:
                                      _onProfilePictureChanged,
                                ),
                                UserActivityTab(user: state.user),
                                UserTribesTab(
                                  user: state.user,
                                  userTribes: state.userTribes,
                                ),
                                const UserPostTab(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (_) =>
                  const Center(child: Text('Error loading user profile')),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: const StyledCustomBottomAppBar.empty(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    switch (widget.visitorType) {
      case VisitorType.tribeOwner:
        return const SizedBox.shrink();
      case VisitorType.visitorSharingTribe:
        return const SizedBox.shrink();
      case VisitorType.outsideVisitor:
        return const SizedBox.shrink();
      case VisitorType.owner:
        return const SizedBox.shrink();
    }
  }
}
