import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:try_grid/app/services/firebase_service.dart';
import '../../service_locator.dart';
import '../blocs/bloc.dart';
import 'my_nodata.dart';
import 'my_refresher.dart';

class MySensorIds extends StatelessWidget {
  final _firebaseService = locator<FirebaseService>();

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
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.querySensorIds(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return MyNoData();
        return Refreshable(
          child: ListView.builder(
              itemCount: snapshot.data.size,
              itemBuilder: (BuildContext context, int index) {
                return _buildListItem(snapshot.data.docs[index]);
              },
          )
        );
      },
    );
  }

  Widget _buildListItem(QueryDocumentSnapshot document) {
    final sensorId = document.data()['sensorId'];
    return ListTile(
      title: Text('$sensorId'),
      trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => _firebaseService.deleteSensorId(sensorId),
      ),
    );
  }

  Stream<QuerySnapshot> _querySensorIds() {
    print('(TRACE) Query with deviceId: $bloc.deviceId');
    return FirebaseFirestore.instance
        .collection('sensors_subs')
        .where('deviceId', isEqualTo: bloc.deviceId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
