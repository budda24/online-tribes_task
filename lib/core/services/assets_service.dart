import 'dart:io';
import 'package:flutter/material.dart';
import 'package:online_tribes/core/extensions/context_extensions.dart';
import 'package:online_tribes/core/models/translation_assets_picker.dart';
import 'package:online_tribes/core/models/translation_camera_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class AssetService {
  // Function to get the appropriate AssetPickerTextDelegate based on language
  AssetPickerTextDelegate getAssetPickerTextDelegate(String languageCode) {
    switch (languageCode) {
      case 'pl':
        return const PolishAssetPickerTextDelegate();
      case 'uk':
        return const UkrainianAssetPickerTextDelegate();
      default:
        return const EnglishAssetPickerTextDelegate();
    }
  }

  // Function to get the appropriate CameraPickerTextDelegate based on language
  CameraPickerTextDelegate getCameraPickerTextDelegate(String languageCode) {
    switch (languageCode) {
      case 'pl':
        return PolishCameraPickerTextDelegate();
      case 'uk':
        return UkrainianCameraPickerTextDelegate();
      default:
        return const EnglishCameraPickerTextDelegate();
    }
  }

  Future<File?> pickFromGallery(
    BuildContext context,
    String languageCode,
  ) async {
    final result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        themeColor: context.appColors.primaryColor,
        maxAssets: 1,
        requestType: RequestType.image,
        textDelegate: getAssetPickerTextDelegate(languageCode),
      ),
    );

    if (result != null && result.isNotEmpty) {
      return result.first.originFile;
    }
    return null;
  }

  Future<File?> takePhoto(BuildContext context, String languageCode) async {
    final result = await CameraPicker.pickFromCamera(
      pickerConfig: CameraPickerConfig(
        textDelegate: getCameraPickerTextDelegate(languageCode),
        theme: ThemeData(
          primaryColor: context.appColors.primaryColor,
        ),
      ),
      context,
    );

    if (result != null) {
      return result.originFile;
    }
    return null;
  }
}
