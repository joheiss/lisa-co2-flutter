import 'package:flutter/material.dart';
import '../services/localstorage_service.dart';

import '../../service_locator.dart';

class MySettings extends StatelessWidget {
  final _storageService = locator<LocalStorageService>();
  TextEditingController _urlController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen anpassen'),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildUrlInputField(context),
            Container(margin: EdgeInsets.only(top: 25.0)),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

Widget _buildUrlInputField(BuildContext context) {
    _urlController = TextEditingController(text: _storageService.serviceUrl);
  return TextField(
    decoration: InputDecoration(
      labelText: 'Service Url',
      hintText: 'Bitte geben Sie hier die Url des Servers ein.',
    ),
    controller: _urlController,
  );
}

Widget _buildSubmitButton(BuildContext context) {
  return RaisedButton(
    onPressed: () async {
      _storageService.saveStringToDisk('service-url', _urlController.text);
    },
    child: Text('Speichern'),
    color: Theme.of(context).accentColor,
  );
}
  void dispose() {
    _urlController.dispose();
  }
}
