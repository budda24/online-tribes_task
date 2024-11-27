import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/fake_translation.dart';
import 'package:online_tribes/features/context_menu/presentation/cubit/context_menu_cubit.dart';
import 'package:online_tribes/features/context_menu/presentation/cubit/context_menu_state.dart';
import 'package:online_tribes/features/context_menu/presentation/widgets/context_menu_tab.dart';
import 'package:online_tribes/features/context_menu/presentation/widgets/tabs/members_tab.dart';
import 'package:online_tribes/features/main_drawer/presentation/widgets/styled_drawer.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/navigation/styled_app_bar.dart';

class ContextMenuPage extends StatefulWidget {
  const ContextMenuPage({super.key});

  @override
  State<ContextMenuPage> createState() => _ContextMenuPageState();
}

class _ContextMenuPageState extends State<ContextMenuPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ContextMenuCubit>().loadTribeData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContextMenuCubit, ContextMenuState>(
      listener: (context, state) {
        state.mapOrNull(
          error: (state) {
            context.showErrorBanner(
              ErrorUtility.getErrorMessage(context, state.error),
            );
          },
        );
      },
      builder: (context, state) {
        return state.maybeMap(
          orElse: () {
            return const Scaffold(
              body: Center(
                child: StyledLoadingIndicatorWidget(),
              ),
            );
          },
          loaded: (state) {
            final members = state.tribe.members ?? [];
            return Scaffold(
              drawer: StyledDrawer(),
              appBar: StyledAppBar.withBackButton(
                title: state.tribe.name,
              ),
              body: SafeArea(
                child: ContextMenuTab(
                  tabs: [
                    Tab(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(context.localizations.contextMenuMembers),
                          Positioned(
                            right: -6.w,
                            top: -7.h,
                            child: Container(
                              width: 14.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: context.appColors.successColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  members.length.toString(),
                                  style:
                                      context.appTextStyles.overline.copyWith(
                                    color: context.appColors.backgroundColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(text: context.localizations.invitations),
                    Tab(text: context.localizations.rules),
                    Tab(text: context.localizations.profiles),
                    Tab(text: context.localizations.categories),
                  ],
                  tabViews: [
                    MembersTab(
                      itemCount: members.length,
                      imageUrls:
                          members.map((e) => e.profilePictureUrl).toList(),
                      names: members.map((e) => e.name).toList(),
                      joinedDates: List.generate(
                        members.length,
                        (index) => 'Joined july 29, 2023',
                      ),
                      locations:
                          List.generate(members.length, (index) => 'Warsaw'),
                      statuses: List.generate(members.length, (index) => true),
                    ),
                    Text(fakeTranslation('Feed General discussion category')),
                    Text(fakeTranslation('Feed General discussion category')),
                    Text(fakeTranslation('Feed General discussion category')),
                    Text(fakeTranslation('Feed General discussion category')),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
