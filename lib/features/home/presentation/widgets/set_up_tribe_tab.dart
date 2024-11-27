import 'package:flutter/material.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar.dart';
import 'package:online_tribes/features/shared/widgets/registration/styled_tab_bar_view.dart';

class SetUpTribeTab extends StatefulWidget {
  final List<Tab> tabs;
  final List<Widget> tabViews;

  const SetUpTribeTab({
    required this.tabs,
    required this.tabViews,
    super.key,
  });

  @override
  State<SetUpTribeTab> createState() => _SetUpTribeTabState();
}

class _SetUpTribeTabState extends State<SetUpTribeTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    assert(
      widget.tabs.length == widget.tabViews.length,
      'Tabs and tab views must have matching lengths',
    );
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StyledTabBar.styledTab(
          canNavigateTapping: true,
          tabs: widget.tabs,
          tabController: _tabController,
          isScrollable: true,
        ),
        Flexible(
          child: StyledTabBarView(
            isScrollable: true,
            tabController: _tabController,
            tabViews: widget.tabViews,
          ),
        ),
      ],
    );
  }
}
