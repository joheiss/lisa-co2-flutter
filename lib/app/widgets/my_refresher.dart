import 'package:flutter/material.dart';
import '../blocs/bloc.dart';

class Refreshable extends StatelessWidget {
  final Widget child;

  Refreshable({this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchSensorIds();
      },
    );
  }

}