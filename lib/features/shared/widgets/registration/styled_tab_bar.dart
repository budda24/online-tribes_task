import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledTabBar extends StatelessWidget {
  final TabController? tabController;
  final List<Tab> tabs;
  final bool canNavigateTapping;
  final TabBarIndicatorSize indicatorSize;
  final bool isScrollable;
  final TabAlignment? tabAlignment;

  const StyledTabBar({
    required this.tabController,
    required this.tabs,
    super.key,
    this.canNavigateTapping = false,
    this.indicatorSize = TabBarIndicatorSize.tab,
    this.isScrollable = false,
    this.tabAlignment,
  });

  const StyledTabBar.styledTab({
    required this.tabController,
    required this.tabs,
    super.key,
    this.canNavigateTapping = false,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.isScrollable = false,
    this.tabAlignment = TabAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !canNavigateTapping,
      child: TabBar(
        indicatorSize: indicatorSize,
        isScrollable: isScrollable,
        tabAlignment: tabAlignment,
        labelStyle: context.appTextStyles.bodyText1
            .copyWith(color: context.appColors.primaryColor),
        unselectedLabelStyle:
            context.appTextStyles.bodyText1.copyWith(color: Colors.grey),
        controller: tabController,
        tabs: [
          ...tabs,
        ],
      ),
    );
  }
}
