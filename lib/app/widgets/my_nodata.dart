import 'package:flutter/material.dart';

class MyNoData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text(
        'Sie haben noch keine Räume abonniert.',
        style: TextStyle(fontSize: 16.0),
        textAlign: TextAlign.center,
      ),
    );
  }
}
