import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/features/shared/widgets/common/blinking_placeholder.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:online_tribes/theme/theme_context_extantion.dart';

class MainPicture extends StatelessWidget {
  final String url;

  const MainPicture.user({
    required this.url,
    super.key,
  });

  const MainPicture.tribe({
    required this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty ? UserAvatar(url) : const DefaultAvatar();
  }
}

class UserAvatar extends StatelessWidget {
  final String url;

  const UserAvatar(
    this.url, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarWrapper(
      child: CachedNetworkImage(
        fit: BoxFit.fitWidth,
        imageUrl: url,
        placeholder: (context, value) => BlinkingPlaceholder(
          localAssetName: Assets.shared.logo.logoSquer.path,
        ),
      ),
    );
  }
}

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarWrapper(
      child: Image.asset(
        Assets.shared.logo.logoSquer.path,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class AvatarWrapper extends StatelessWidget {
  final Widget child;

  const AvatarWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.h,
      width: 105.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 9.h,
          horizontal: 10.w,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.r),
          child: child,
        ),
      ),
    );
  }
}
