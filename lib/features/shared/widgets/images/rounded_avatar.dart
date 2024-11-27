import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/features/shared/widgets/common/blinking_placeholder.dart';
import 'package:online_tribes/gen/assets.gen.dart';

class RoundedAvatar extends StatelessWidget {
  final String avatarUrl;

  const RoundedAvatar(this.avatarUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: CachedNetworkImage(
        imageUrl: avatarUrl,
        height: 40.h,
        width: 40.w,
        fit: BoxFit.cover,
        placeholder: (context, value) => BlinkingPlaceholder(
          localAssetName: Assets.shared.logo.logoSquer.path,
        ),
        errorWidget: (context, url, error) => Image.asset(
          Assets.shared.downloadingError.path,
        ),
      ),
    );
  }
}
