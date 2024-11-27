import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/gen/assets.gen.dart';
import 'package:shimmer/shimmer.dart';

// For now just fake pictures. Need to discuss from where it will be taken
class TribeProfileGallery extends StatelessWidget {
  final fakeProfilePictures = [
    Assets.shared.fakeTribeProfileGallery.fakeTribeGalleryPhoto1.path,
    Assets.shared.fakeTribeProfileGallery.fakeTribeGalleryPhoto2.path,
    Assets.shared.fakeTribeProfileGallery.fakeTribeGalleryPhoto3.path,
    Assets.shared.fakeTribeProfileGallery.fakeTribeGalleryPhoto1.path,
    Assets.shared.fakeTribeProfileGallery.fakeTribeGalleryPhoto2.path,
    Assets.shared.fakeTribeProfileGallery.fakeTribeGalleryPhoto3.path,
  ];

  TribeProfileGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        scrollDirection: Axis.horizontal,
        itemCount: fakeProfilePictures.length,
        separatorBuilder: (context, index) => 10.horizontalSpace,
        itemBuilder: (context, index) {
          final item = fakeProfilePictures[index];

          return TribeProfileGalleryPicture(item);
        },
      ),
    );
  }
}

class TribeProfileGalleryPicture extends StatelessWidget {
  final String imageUrl;

  const TribeProfileGalleryPicture(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    // Uncomment this code when the real images will be available
    // return CachedNetworkImage(
    //   imageUrl: imageUrl,
    //   height: 80.h,
    //   width: 90.w,
    //   fit: BoxFit.cover,
    //   placeholder: (context, value) => const ShimmerPlaceholder(),
    //   errorWidget: (context, url, error) => Image.asset(
    //     Assets.shared.downloadingError.path,
    //   ),
    // );

    return Image.asset(
      imageUrl,
      height: 80.h,
      width: 90.w,
      fit: BoxFit.fitWidth,
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
        height: 80.h,
        width: 90.w,
      ),
    );
  }
}
