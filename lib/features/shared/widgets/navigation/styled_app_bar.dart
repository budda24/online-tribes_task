import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool isBackButton;
  final bool hasDrawer;
  final double backButtonIconSize;
  final VoidCallback? onBackButtonPressed;

  const StyledAppBar({
    this.title,
    this.actions,
    this.leading,
    this.isBackButton = false,
    this.hasDrawer = false,
    this.backButtonIconSize = 30.0, // default size for back button
    this.onBackButtonPressed,
  });

  /// Named constructor for app bar with drawer.
  const StyledAppBar.withDrawer({
    this.title,
    this.actions,
    this.leading,
    this.isBackButton = false,
    this.hasDrawer = true,
    this.backButtonIconSize = 30.0,
    this.onBackButtonPressed,
  });

  /// Named constructor for a styled app bar with a back button.
  const StyledAppBar.withBackButton({
    this.title,
    this.actions,
    this.isBackButton = true,
    this.hasDrawer = false,
    this.backButtonIconSize = 30.0,
    this.onBackButtonPressed,
  }) : leading = null;

  /// Named constructor for a custom app bar configuration.
  const StyledAppBar.custom({
    this.title,
    this.actions,
    this.leading,
    this.isBackButton = false,
    this.hasDrawer = false,
    this.backButtonIconSize = 30.0,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    if (isBackButton) {
      leadingWidget = IconButton(
        onPressed: onBackButtonPressed ??
            () {
              if (context.router.canPop()) {
                context.router.pop();
              }
            },
        icon: Icon(
          Icons.arrow_back_sharp,
          size: backButtonIconSize,
        ),
      );
    } else if (hasDrawer) {
      leadingWidget = IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: Icon(
          Icons.menu_rounded,
          color: context.appColors.textColor,
        ),
      );
    } else {
      leadingWidget = leading;
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        title: Text(title ?? ''),
        elevation: 0,
        leading: leadingWidget,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
