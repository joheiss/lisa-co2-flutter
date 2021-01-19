import 'package:flutter/material.dart';

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
      child: Text('Hier kommen Informationen über die App hin ...'),
    );
  }
}
