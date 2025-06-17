import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class StoragePermissionHelper {
  static Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) return true;

      final videosStatus = await Permission.videos.status;
      final audioStatus = await Permission.audio.status;

      return videosStatus.isGranted || audioStatus.isGranted;
    }
    return true;
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }

      final videosStatus = await Permission.videos.request();
      final audioStatus = await Permission.audio.request();

      return videosStatus.isGranted || audioStatus.isGranted;
    }
    return true;
  }
}
