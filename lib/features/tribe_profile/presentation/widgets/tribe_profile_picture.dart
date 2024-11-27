import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:shimmer/shimmer.dart';

class TribeProfilePicture extends StatelessWidget {
  final String imageUrl;

  const TribeProfilePicture(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.r),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 190.h,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, value) => const ShimmerPlaceholder(),
          errorWidget: (context, url, error) => Image.asset(
            Assets.shared.downloadingError.path,
          ),
        ),
      ),
    );
  }
}

class ShimmerPlaceholder extends StatelessWidget {
  const ShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.appColors.shimmerBaseColor,
      highlightColor: context.appColors.shimmerHighlightColor,
      child: Container(
        color: Colors.black,
        height: 190.h,
        width: double.infinity,
      ),
    );
  }
}
