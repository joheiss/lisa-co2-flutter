import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/blocs/bloc.dart';
import 'service_locator.dart';
import 'app/app.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await setupLocator();
    await Bloc.getDeviceId();
    runApp(App());
  } catch (err) {
    print('(ERROR) Locator setup failed: $err');
  }
}
