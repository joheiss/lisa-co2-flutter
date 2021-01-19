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
              onPressed: () async {
                String id = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Abbrechen', true, ScanMode.BARCODE);
                if (id == null) return;
                if (id == '-1') id = 'oho-oho-${DateTime.now().millisecond}';
                Navigator.popAndPushNamed(context, '/barcode/$id');
              },
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
}
