import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceService {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    String deviceId;
    try {
      if (Platform.isAndroid) {
        final data = await deviceInfo.androidInfo;
        deviceId = data.androidId;
      }
      if (Platform.isIOS) {
        final data = await deviceInfo.iosInfo;
        deviceId = data.identifierForVendor;
      }
    } on PlatformException {
      deviceId = '';
    }
    return deviceId;
  }
}
