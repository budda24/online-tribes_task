import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/di/configure_dependencies.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/features/shared/widgets/buttons/styled_filled_button.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_shimmer_app_bar.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/models/enum/tribe_profile_visitor_status.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/models/tribe_profile_data.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_cubit.dart';
import 'package:online_tribes/features/tribe_profile/presentation/cubit/tribe_profile_state.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tabs/tribe_profile_about_tab.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tabs/tribe_profile_activity_tab.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tabs/tribe_profile_members_tab.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tabs/tribe_profile_rules_tab.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tribe_dialog.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tribe_profile_gallery.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tribe_profile_members_info.dart';
import 'package:online_tribes/features/tribe_profile/presentation/widgets/tribe_profile_picture.dart';

class TribeProfilePage extends StatefulWidget {
  final String tribeId;

  const TribeProfilePage({
    required this.tribeId,
    super.key,
  });

  @override
  State<TribeProfilePage> createState() => _TribeProfilePageState();
}

class _TribeProfilePageState extends State<TribeProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<TribeProfileCubit>().loadTribeData(widget.tribeId),
    );
  }

  Widget _buildSliverAppBar(TribeProfileState state) {
    return state.maybeWhen(
      loaded: (stateData) => SliverAppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text(stateData.tribe.name),
        ),
      ),
      orElse: () => const SliverAppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          background: StyledShimmerAppBar(),
        ),
      ),
    );
  }

  Widget _buildBottomButton(TribeProfileState state) {
    return state.maybeWhen(
      loaded: (data) {
        if (data.visitorStatus.isMember ||
            data.visitorStatus.isOwner ||
            data.visitorStatus.hasRequestPending ||
            data.visitorStatus.joinRequestSent) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 20.h,
          left: 16.w,
          right: 16.w,
          child: StyledFilledButton(
            buttonText: context.localizations.joinTheGroup,
            onPressed: () => showDialog<void>(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return TribeDialog(
                  onSendPressed:
                      context.read<TribeProfileCubit>().sendJoinRequest,
                  requestMessageController: TextEditingController(),
                );
              },
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  void _handleLoadedState(TribeProfileData stateData) {
    if (stateData.visitorStatus.joinRequestSent) {
      getIt<BannerService>().showInfoBanner(
        context: context,
        message: context.localizations.joinRequestSent,
      );
    } else if (stateData.visitorStatus.hasRequestPending) {
      getIt<BannerService>().showInfoBanner(
        context: context,
        message: context.localizations.joinRequestPendingApproval,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TribeProfileCubit, TribeProfileState>(
      listener: (context, state) => state.maybeWhen(
        failure: (_) => getIt<BannerService>().showErrorBanner(
          context: context,
          message: context.localizations.unknownError,
        ),
        loaded: _handleLoadedState,
        orElse: () => {},
      ),
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _buildSliverAppBar(state),
                  state.maybeWhen(
                    loading: () => const SliverFillRemaining(
                      child: Center(
                        child: StyledLoadingIndicatorWidget(),
                      ),
                    ),
                    loaded: (stateData) => SliverToBoxAdapter(
                      child: TribeProfilePageContentLoaded(
                        stateData,
                      ),
                    ),
                    failure: (_) => const SliverFillRemaining(
                      child: Center(
                        child: StyledLoadingIndicatorWidget(),
                      ),
                    ),
                    orElse: () => const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 90.h,
                    ),
                  ),
                ],
              ),
              _buildBottomButton(state),
            ],
          ),
        );
      },
    );
  }
}

class TribeProfilePageContentLoaded extends StatelessWidget {
  final TribeProfileData stateData;

  const TribeProfilePageContentLoaded(
    this.stateData, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TribeProfilePicture(
                  stateData.tribe.signUrl ?? '',
                ),
                TribeProfileGallery(),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    stateData.tribe.name,
                    style: context.appTextStyles.headline2,
                  ),
                ),
                8.verticalSpace,
                TribeProfileMembersInfo(
                  stateData.tribe.members,
                  ownerName: stateData.tribe.ownerName!,
                ),
                TabsSection(stateData),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TabsSection extends StatefulWidget {
  final TribeProfileData stateData;

  const TabsSection(
    this.stateData, {
    super.key,
  });

  @override
  State<TabsSection> createState() => _TabsSectionState();
}

class _TabsSectionState extends State<TabsSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  var _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabSelected);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabSelected() {
    if (_selectedTabIndex == _tabController.index) {
      return;
    }

    setState(() => _selectedTabIndex = _tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StyledTabBar(
          canNavigateTapping: true,
          tabController: _tabController,
          tabs: [
            Tab(text: context.localizations.userProfileTabAbout),
            Tab(text: context.localizations.rulesTab),
            Tab(text: context.localizations.userProfileTabActivity),
            Tab(text: context.localizations.members),
          ],
        ),
        _buildTabBarView(),
      ],
    );
  }

  Widget _buildTabBarView() {
    switch (_selectedTabIndex) {
      case 0:
        return TribeProfileAboutTab(widget.stateData.tribe);
      case 1:
        return TribeProfileRulesTab(widget.stateData.overallRules);
      case 2:
        return TribeProfileActivityTab(widget.stateData);
      case 3:
        return TribeProfileMembersTab(widget.stateData.tribe);
      default:
        return const SizedBox.shrink();
    }
  }
}
