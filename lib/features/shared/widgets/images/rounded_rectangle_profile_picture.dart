import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/gen/assets.gen.dart';

class RoundedRectangleProfilePicture extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;

  const RoundedRectangleProfilePicture({
    required this.imageUrl,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty)
        ? Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: context.appColors.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                context.appWidgetStyles
                    .customColorDropShadow(context.appColors.primaryColor),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                width: 90.w,
                height: 90.h,
                child: _buildImage(),
              ),
            ),
          )
        : _buildPlaceholderImage();
  }

  Widget _buildImage() {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: 85.w,
        height: 85.h,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: 85.w,
        height: 85.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholderImage(),
        errorWidget: (context, url, error) => _buildPlaceholderImage(),
      );
    } else {
      return _buildPlaceholderImage();
    }
  }

  Widget _buildPlaceholderImage() {
    return Assets.shared.logo.logoSquerGrey
        .image(width: 90.w, height: 90.h, fit: BoxFit.cover);
  }
}
