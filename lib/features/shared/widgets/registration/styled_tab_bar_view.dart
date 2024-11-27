// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class StyledTabBarView extends StatelessWidget {
  final TabController? tabController;
  final List<Widget> tabViews;
  final bool isScrollable;

  const StyledTabBarView({
    required this.tabController,
    required this.tabViews,
    this.isScrollable = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: isScrollable ? null : const NeverScrollableScrollPhysics(),
      controller: tabController,
      children: tabViews,
    );
  }
}
