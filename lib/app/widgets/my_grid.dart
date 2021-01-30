import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../blocs/bloc.dart';
import 'my_nodata.dart';
import 'my_drawer.dart';
import 'my_grid_item.dart';

class MyGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meine Räume'),
      ),
      drawer: MyDrawer(),
      body: _buildGrid(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/barcode'),
        tooltip: 'Barcode einlesen',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: bloc.querySensorIds(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return MyNoData();
        if (snapshot.data.size == 0) return MyNoData();
        // snapshot.data.docs.forEach((d) {
        //   print('(TRACE) list item id: ${d.id}');
        //   print('(TRACE) list item deviceId: ${d.data()["deviceId"]}');
        //   print('(TRACE) list item deviceId: ${d.data()["sensorId"]}');
        // });
        return GridView.builder(
          padding: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: snapshot.data.size > 1 ? 2 : 1,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            ),
          itemCount: snapshot.data.size,
          itemBuilder: (BuildContext context, int index) {
            // print('(TRACE) Sensor Id from list (index $index): ${snapshot.data.docs[index]["sensorId"]}');
            return MyGridItem(id: snapshot.data.docs[index]['sensorId']);
          },
        );
      },
    );
  }
}
