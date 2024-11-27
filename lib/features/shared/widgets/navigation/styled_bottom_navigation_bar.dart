import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledCustomBottomAppBar extends StatelessWidget {
  final List<TabItem>? tabs;
  final int? currentIndex;
  final ValueChanged<int>? onTabSelected;
  final bool isEmpty;

  // Named constructor for BottomAppBar with tabs
  const StyledCustomBottomAppBar.withTabs({
    this.currentIndex,
    super.key,
    this.tabs,
    this.onTabSelected,
  }) : isEmpty = false;

  // Named constructor for an empty BottomAppBar
  const StyledCustomBottomAppBar.empty({
    super.key,
  })  : tabs = null,
        currentIndex = null,
        onTabSelected = null,
        isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 20,
      shadowColor: context.appColors.shadowColor,
      color: context.appColors.secondaryColor,
      notchMargin: 30.h,
      shape: const CircularNotchedRectangle(),
      child: isEmpty
          ? const SizedBox(
              height: kBottomNavigationBarHeight,
            )
          : Row(
              children: [
                // Left side tabs
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        tabs!.sublist(0, (tabs!.length / 2).ceil()).map((tab) {
                      final isActive = currentIndex == tab.index;
                      return IconButton(
                        onPressed: () {
                          onTabSelected?.call(tab.index);
                        },
                        icon: Icon(
                          isActive ? tab.activeIcon : tab.icon,
                          color: isActive
                              ? context.appColors.primaryColor
                              : context.appColors.secondaryColor,
                          size: 30.r,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Right side tabs
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        tabs!.sublist((tabs!.length / 2).ceil()).map((tab) {
                      final isActive = currentIndex == tab.index;
                      return IconButton(
                        onPressed: () {
                          onTabSelected?.call(tab.index);
                        },
                        icon: Icon(
                          isActive ? tab.activeIcon : tab.icon,
                          color: isActive
                              ? Theme.of(context).primaryColor
                              : context.appColors.secondaryColor,
                          size: 30.r,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}

class TabItem {
  final int index;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  TabItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
