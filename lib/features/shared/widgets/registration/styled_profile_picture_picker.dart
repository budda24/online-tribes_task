import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/services/assets_service.dart';
import 'package:online_tribes/core/services/banner_service.dart';
import 'package:online_tribes/core/services/permission_service.dart';
import 'package:online_tribes/features/shared/widgets/images/rounded_rectangle_profile_picture.dart';
import 'package:online_tribes/gen/assets.gen.dart';

class StyledProfilePicturePicker extends StatefulWidget {
  final void Function(File?) onImagePicked;
  final String? initialImageUrl;
  final File? initialImageFile;

  const StyledProfilePicturePicker({
    required this.onImagePicked,
    super.key,
    this.initialImageUrl,
    this.initialImageFile,
  });
  @override
  State<StyledProfilePicturePicker> createState() =>
      StyledProfilePicturePickerState();
}

class StyledProfilePicturePickerState
    extends State<StyledProfilePicturePicker> {
  final AssetService _assetService = GetIt.I<AssetService>();
  final PermissionService _permissionService = GetIt.I<PermissionService>();
  File? _image;

  Future<void> _pickImage() async {
    final permissionGranted =
        await _permissionService.requestStorageOrPhotosPermission();

    if (permissionGranted) {
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: context.appColors.primaryColor,
                  ),
                  title: Text(
                    context.localizations.picturePickerPickFromGallery,
                    style: context.appTextStyles.subtitle2,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    _image = await _assetService.pickFromGallery(
                      context,
                      context.localizations.localeName,
                    );
                    setState(() {
                      widget.onImagePicked(_image);
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_camera,
                    color: context.appColors.primaryColor,
                  ),
                  title: Text(
                    context.localizations.picturePickerTakePicture,
                    style: context.appTextStyles.subtitle2,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    _image = await _assetService.takePhoto(
                      context,
                      context.localizations.localeName,
                    );
                    setState(() {
                      widget.onImagePicked(_image);
                    });
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Handle permission denied or permanently denied
      if (!mounted) return;
      BannerService().showBanner(
        message: context.localizations.picturePickerPermissionDeniedMessage,
        context: context,
      );
    }
  }

  @override
  void initState() {
    _image = widget.initialImageFile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              // Display the image or a placeholder
              if (_image != null || widget.initialImageUrl != null)
                RoundedRectangleProfilePicture(
                  imageFile: _image,
                  imageUrl: widget.initialImageUrl,
                )
              else
                Assets.shared.logo.logoSquerGrey.image(
                  width: 90.w,
                  height: 90.h,
                  fit: BoxFit.cover,
                ),
              // Position the icon at the top-left corner
              Positioned(
                top: 0,
                left: 0,
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 40,
                  color: context.appColors
                      .primaryColor, // Optional: adjust color for visibility
                ),
              ),
            ],
          ),
          // Display the text if no image is selected
          if (_image == null && widget.initialImageUrl == null)
            Text(
              context.localizations.picturePickerAddPicture,
              style: context.appTextStyles.subtitle1.copyWith(
                color: context.appColors.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
