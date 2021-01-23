import 'package:flutter/material.dart';
import 'package:try_grid/app/widgets/my_login.dart';
import 'widgets/my_form.dart';
import 'services/firebase_service.dart';
import 'widgets/my_sensor_ids.dart';
import '../service_locator.dart';
import 'blocs/bloc.dart';
import 'widgets/my_barcode.dart';
import 'widgets/my_detail.dart';
import 'widgets/my_grid.dart';
import 'widgets/my_info.dart';
import 'widgets/my_theme.dart';
import 'widgets/my_settings.dart';

class App extends StatelessWidget {
  final String _deviceId;
  final _firebaseService = locator<FirebaseService>();

  App(this._deviceId) {
    bloc.deviceId = _deviceId;
  }

  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      title: 'Meine Räume',
      theme: MyTheme.darkTheme(),
      onGenerateRoute: _generateRoute,
    );
  }

  Route<Widget> _generateRoute(RouteSettings settings) {
    final uid = _firebaseService.getCurrentUserId();
    print('(TRACE) Logged in user: $uid');
    print('(TRACE) Navigation target: ${settings.name}');
    if (uid == null || settings.name == '/signin')
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return MyLogin();
        },
      );
    if (settings.name == '/info')
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return MyInfo();
        },
      );
    if (settings.name.startsWith('/detail/'))
      return MaterialPageRoute(
        builder: (BuildContext context) {
          final id = settings.name.replaceFirst('/detail/', '');
          bloc.getInitialOptions(id);
          return MyDetail(id: id);
        },
      );
    if (settings.name == '/barcode')
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return MyBarcode();
        },
      );
    if (settings.name.startsWith('/barcode/'))
      return MaterialPageRoute(
        builder: (BuildContext context) {
          final id = settings.name.replaceFirst('/barcode/', '');
          _firebaseService.createSensorId(id);
          return MyForm(id: id);
        },
      );
    if (settings.name == '/settings')
      return MaterialPageRoute(
        builder: (BuildContext context) {
          return MySettings();
        },
      );
    if (settings.name == '/reset')
      return MaterialPageRoute(
        builder: (BuildContext context) {
          // bloc.fetchSensorIds();
          return MySensorIds();
        },
      );
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return MyGrid();
      },
    );
  }
}
