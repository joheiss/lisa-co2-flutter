import 'package:flutter/material.dart';

class Refreshable extends StatelessWidget {
  final Widget child;

  Refreshable({this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        // ich glaube, den brauche ich nicht mehr. 
        // await bloc.fetchSensorIds();
      },
    );
  }

}