import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  //manage permission of storage and take action
  static Future<bool> storageKiDekhaJabe() async {
    bool isOk;
    if (await Permission.storage.request() != PermissionStatus.granted) {
      openAppSettings();
      isOk = false;
    } else {
      isOk = true;
    }
    return isOk;
  }

  //manage permission of location
  static Future<bool> locationAccessDiba() async {
    bool isOk;
    if (await Permission.location.request() != PermissionStatus.granted) {
      openAppSettings();
      isOk = false;
    } else {
      isOk = true;
    }
    return isOk;
  }

  //manage permission of location
  static Future<bool> bluetoothAccessDiba() async {
    bool isOk;
    if (await Permission.bluetooth.request() != PermissionStatus.granted &&
        await Permission.bluetoothConnect.request() !=
            PermissionStatus.granted &&
        await Permission.bluetoothScan.request() != PermissionStatus.granted) {
      //happy rose day 2023. the issue solved today was with android version 12 which requires some extra permission
      openAppSettings();
      isOk = false;
    } else {
      isOk = true;
    }
    return isOk;
  }
}
