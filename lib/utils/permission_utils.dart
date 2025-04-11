import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  /// Meminta izin kamera
  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      return await Permission.camera.request().isGranted;
    }
    return status.isGranted;
  }

  /// Meminta izin galeri
  static Future<bool> requestGalleryPermission() async {
    var status = await Permission.photos.status;
    if (status.isDenied) {
      return await Permission.photos.request().isGranted;
    }
    return status.isGranted;
  }

  /// Membuka pengaturan aplikasi jika izin ditolak permanen
  static Future<void> openAppSettingsIfPermanentlyDenied() async {
    if (await Permission.camera.isPermanentlyDenied ||
        await Permission.photos.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}
