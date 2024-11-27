import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/error/error_utility.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/utils/fake_translation.dart';
import 'package:online_tribes/features/home/presentation/cubit/home_page_cubit.dart';
import 'package:online_tribes/features/home/presentation/cubit/home_page_state.dart';
import 'package:online_tribes/features/home/presentation/widgets/home_page_icon_button.dart';
import 'package:online_tribes/features/home/presentation/widgets/home_page_text_field.dart';
import 'package:online_tribes/features/home/presentation/widgets/set_up_expansion_tile.dart';
import 'package:online_tribes/features/home/presentation/widgets/set_up_tribe_tab.dart';
import 'package:online_tribes/features/main_drawer/presentation/widgets/styled_drawer.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_loading_indicator_widget.dart';
import 'package:online_tribes/features/shared/widgets/common/styled_main_padding_widget.dart';
import 'package:online_tribes/features/shared/widgets/navigation/styled_app_bar.dart';
import 'package:online_tribes/features/user_registration/presentation/widgets/main_picture.dart';
import 'package:online_tribes/router/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    context.read<HomePageCubit>().loadUserData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageCubit, HomePageState>(
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
            return Scaffold(
              backgroundColor: context.appColors.backgroundColor,
              key: _scaffoldKey,
              drawer: StyledDrawer(),
              appBar: StyledAppBar.withDrawer(
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomePageIconButton(
                        icon: Icons.more_horiz_rounded,
                        onPressed: () {
                          ContextMenuRoute().go(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              body: SafeArea(
                child: StyledMainPadding.small(
                  child: Column(
                    children: [
                      MainPicture.tribe(
                        url: state.tribe.signUrl!,
                      ),
                      30.verticalSpace,
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              state.user.information!.profilePictureUrl!,
                            ),
                          ),
                          16.horizontalSpace,
                          Expanded(
                            child: HomePageTextField(
                              hintText: context.localizations.writeSomething,
                              onValueChanged: (value) {},
                              onClearButtonTap: () {},
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      if (!state.tribe.tribeSetUpStatus.isFinished)
                        Expanded(
                          child: SetUpTribeTab(
                            tabs: [
                              Tab(
                                text: context.localizations.all,
                              ),
                              Tab(
                                text: context.localizations.generalDiscussion,
                              ),
                            ],
                            tabViews: [
                              SetUpExpansionTile(
                                tribeSetUpStatus: state.tribe.tribeSetUpStatus,
                              ),
                              Center(
                                child: Text(
                                  fakeTranslation(
                                    'Feed General discussion category',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
