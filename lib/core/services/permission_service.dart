import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Request the appropriate permission based on Android SDK version.
  Future<bool> requestStorageOrPhotosPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt <= 32) {
        // SDK <= 32, request storage permission
        return requestPermission(Permission.storage);
      } else {
        // SDK > 32, request photos permission (Android 13+)
        return requestPermission(Permission.photos);
      }
    } else {
      // Handle non-Android platforms (if necessary)
      return false;
    }
  }

  /// Request a specific permission
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      // Open app settings if the permission is permanently denied
      await openAppSettings();
    }
    return false;
  }

  /// Check if a specific [Permission] is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    return permission.isGranted;
  }
}
