import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/blocs/bloc.dart';
import 'app/services/device_service.dart';
import 'service_locator.dart';
import 'app/app.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await setupLocator();
    final _deviceService = locator<DeviceService>();
    final deviceId = await _deviceService.getDeviceId();
    runApp(App(deviceId));
    // await _getDeviceId();
    // runApp(App());
  } catch (err) {
    print('(ERROR) Locator setup failed!');
    print(err);
  }
}

// Future<String> _getDeviceId() async {
//   final _deviceService = locator<DeviceService>();
//   final deviceId = await _deviceService.getDeviceId();
//   bloc.deviceId = deviceId;
// }
