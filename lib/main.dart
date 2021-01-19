import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'service_locator.dart';
import 'app/app.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await setupLocator();
    runApp(App());
  } catch(err) {
    print('(ERROR) Locator setup failed!');
    print(err);
  }
}
 