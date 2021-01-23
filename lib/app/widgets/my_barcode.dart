import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class MyBarcode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode einlesen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RaisedButton(
              onPressed: () => _scanBarcode(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.scanner),
                  Padding(padding: EdgeInsets.only(right: 10.0)),
                  Text('Barcode scannen'),
                ],
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scanBarcode(BuildContext context) async {
    String id = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Abbrechen', true, ScanMode.BARCODE);
    print('(TRACE) Scanned id: $id');
    if (id == null || id == '-1') return;
    Navigator.popAndPushNamed(context, '/barcode/$id');
  }
}
