import 'package:flutter/material.dart';
import 'my_refresher.dart';
import '../blocs/bloc.dart';
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
        child: Icon(Icons.add)),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return StreamBuilder(
      stream: bloc.sensorIds,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return Refreshable(
          child: GridView.builder(
            padding: EdgeInsets.only(top: 10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: snapshot.data.length > 1 ? 2 : 1,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              bloc.fetchSensor(snapshot.data[index]);
              return MyGridItem(id: snapshot.data[index]);
            },
          ),
        );
      },
    );
  }
}
