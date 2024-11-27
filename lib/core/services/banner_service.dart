import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';

import 'package:online_tribes/gen/assets.gen.dart';

class BannerService {
  void showBanner({
    required BuildContext context,
    required String message,
    SvgGenImage? icon,
    String? titleMessage,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 10),
    Widget? leading,
    List<Widget>? actions,
  }) {
    OverlayEntry?
        overlayEntry; // Declare OverlayEntry as nullable so it can be removed later

    final banner = _buildMaterialBanner(
      context: context,
      message: message,
      backgroundColor: backgroundColor ?? context.appColors.secondaryColor,
      leading: leading,
      actions: actions,
      titleMessage: titleMessage ?? '',
      icon: icon!,
      onDismiss: () {
        overlayEntry?.remove();
      },
    );

    overlayEntry = OverlayEntry(
      builder: (context) {
        return BannerAnimation(
          banner: banner,
          duration: duration,
        );
      },
    );

    // Insert the overlay entry into the overlay stack.
    Overlay.of(context).insert(overlayEntry);

    // Auto-dismiss the banner after the specified duration
    Future.delayed(duration, overlayEntry.remove);
  }

  MaterialBanner _buildMaterialBanner({
    required BuildContext context,
    required String titleMessage,
    required String message,
    required Color backgroundColor,
    required SvgGenImage icon,
    required VoidCallback onDismiss, // Add a callback to handle dismissal
    Widget? leading,
    List<Widget>? actions,
  }) {
    return MaterialBanner(
      content: GestureDetector(
        onTap: onDismiss, // Dismiss the banner when tapped
        child: Padding(
          padding: EdgeInsets.only(
            top: 40.h,
            bottom: 30.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon.svg(
                width: 26.r,
                height: 26.r,
              ),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleMessage,
                      style: context.appTextStyles.subtitle2BOld.copyWith(
                        color: context.appColors.scaffoldBackgroundColor,
                      ),
                    ),
                    Text(
                      message,
                      style: context.appTextStyles.subtitle2.copyWith(
                        color: context.appColors.scaffoldBackgroundColor,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      leading: leading,
      elevation: 3, // Adds elevation to create a shadow
      shadowColor: context.appColors.primaryColor.withOpacity(0.3),
      actions: actions ?? [const SizedBox.shrink()],
    );
  }

  void showErrorBanner({
    required BuildContext context,
    required String message,
  }) {
    showBanner(
      context: context,
      titleMessage: context.localizations.errorBannerTitle,
      message: message,
      icon: Assets.banner.error,
      backgroundColor: context.appColors.errorColor,
    );
  }

  void showInfoBanner({
    required BuildContext context,
    required String message,
  }) {
    showBanner(
      context: context,
      titleMessage: context.localizations.infoBannerTitle,
      message: message,
      icon: Assets.banner.information,
      backgroundColor: context.appColors.primaryColor,
    );
  }

  void showSuccessBanner({
    required BuildContext context,
    required String message,
  }) {
    showBanner(
      context: context,
      titleMessage: context.localizations.successBannerTitle,
      message: message,
      icon: Assets.banner.success,
      backgroundColor: context.appColors.successColor,
    );
  }
}

class BannerAnimation extends StatefulWidget {
  final MaterialBanner banner;
  final Duration duration;

  const BannerAnimation({
    required this.banner,
    required this.duration,
  });

  @override
  State<BannerAnimation> createState() => _BannerAnimationState();
}

class _BannerAnimationState extends State<BannerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // Start from above the screen
      end: Offset.zero, // Slide into position
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.banner,
        ),
      ),
    );
  }
}
