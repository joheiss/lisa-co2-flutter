import 'package:flutter/material.dart';
import 'widgets/my_barcode.dart';
import 'widgets/my_detail.dart';
import 'widgets/my_form.dart';
import 'widgets/my_grid.dart';
import 'widgets/my_info.dart';
import 'widgets/my_login.dart';
import 'widgets/my_sensor_ids.dart';

import 'blocs/bloc.dart';

class MyRouter {

  Route<Widget> generateRoute(RouteSettings settings) {
    final uid = bloc.getCurrentUserId();

    // print('(TRACE) Logged in user: $uid');
    // print('(TRACE) Navigation target: ${settings.name}');

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
          // bloc.getInitialOptions(id);
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
          bloc.addSensorId(id);
          return MyForm(id: id);
        },
      );
    if (settings.name == '/reset')
      return MaterialPageRoute(
        builder: (BuildContext context) {
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
