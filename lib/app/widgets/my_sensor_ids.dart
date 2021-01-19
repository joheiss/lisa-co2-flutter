import 'package:flutter/material.dart';
import '../blocs/bloc.dart';
import 'my_refresher.dart';

class MySensorIds extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meine Räume löschen'),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return StreamBuilder(
      stream: bloc.sensorIds,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        return Refreshable(
          child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem(snapshot.data[index]);
              },
          )
        );
      },
    );
  }

  Widget _buildListItem(String id) {
    return ListTile(
      title: Text('$id'),
      trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => bloc.deleteSensorId(id),
      ),
    );
  }
}
