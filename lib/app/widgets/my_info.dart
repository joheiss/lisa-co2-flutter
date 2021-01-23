import 'package:flutter/material.dart';
import '../blocs/bloc.dart';

class MyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
      ),
      body: _buildInfo(),
    );
  }

  Widget _buildInfo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Hier kommen Informationen über die App hin ... ${bloc.deviceId}'),
          Text('Angemeldet als: ${bloc.user.email}', style: TextStyle(fontSize: 20.0)),
          Text('Device ID: ${bloc.deviceId}', style: TextStyle(fontSize: 20.0)),
          Text('App Version: ${bloc.version}', style: TextStyle(fontSize: 20.0)),
        ],
      ),
    );
  }
}
