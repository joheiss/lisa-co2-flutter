import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../blocs/bloc.dart';
import '../models/sensor_model.dart';

class FirebaseService {
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  final fcm = FirebaseMessaging();

  Stream<QuerySnapshot> querySensorIds() {
    final uid = getCurrentUserId();
    print('(TRACE) Query with userId: $uid');
    return store
        .collection('sensors_subs_user')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> querySensor(id) {
    print('(TRACE) Query sensor with id: $id');
    return store.collection('sensors').doc('$id').snapshots();
  }

  Stream<Sensor> querySensorWithAllMeasurements(id) {
    print('(TRACE) Query sensor with id: $id');
    return store.collection('sensors').doc('$id').get().then((doc) {
      return doc.reference.collection('measurements').orderBy('time', descending: true).get().then((meas) {
        final measurements = <SensorMeasurement>[];
        meas.docs.forEach((m) {
          measurements.add(SensorMeasurement.fromJSON(m.data()));
        });
        return Sensor.fromFSWithMeasurements(doc.id, doc.data(), measurements);
      });
    }).asStream();
  }

  Stream<Sensor> querySensorWithLastMeasurement(id) {
    print('(TRACE) Query sensor with id: $id');
    return store.collection('sensors').doc('$id').get().then((doc) {
      return doc.reference.collection('measurements').orderBy('time', descending: true).limit(1).get().then((meas) {
        final measurements = <SensorMeasurement>[];
        meas.docs.forEach((m) {
          measurements.add(SensorMeasurement.fromJSON(m.data()));
        });
        return Sensor.fromFSWithMeasurements(doc.id, doc.data(), measurements);
      });
    }).asStream();
  }

  Future<void> createSensorId(String sensorId) async {
    final createdAt = Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    return store
        .collection('sensors_subs_user')
        .where('userId', isEqualTo: bloc.user.uid)
        .where('sensorId', isEqualTo: sensorId)
        .limit(1)
        .get()
        .then((value) async {
      if (value.size == 0) {
        final ref = await store
            .collection('sensors_subs_user')
            .add({'userId': bloc.user.uid, 'sensorId': sensorId, 'createdAt': createdAt});
        return ref;
      } else {
        // update createdAt if sensor is scanned again to get it in top position.
        final ref = value.docs.first.reference;
        final batch = store.batch();
        batch.set(ref, {'userId': bloc.user.uid, 'sensorId': sensorId, 'createdAt': createdAt} );
       return batch.commit();
      }
    });
  }

  Future<void> deleteSensorId(String sensorId) async {
    return store
        .collection('sensors_subs_user')
        .where('userId', isEqualTo: bloc.user.uid)
        .where('sensorId', isEqualTo: sensorId)
        .limit(1)
        .get()
        .then((value) async {
      final id = value.docs.first.id;
      final ref = value.docs.first.reference;
      print('(TRACE) Delete sensorId $id');
      await store.runTransaction((tx) async {
        tx.delete(ref);
      });
    });
  }

  Future<void> updateSensor(Sensor sensor) async {
    return FirebaseFirestore.instance.collection('sensors').doc('${sensor.id}').get().then((doc) {
      if (!doc.exists) return null;
      return doc.reference.update({
        'name': sensor.name,
        'description': sensor.description,
        'comment': sensor.comment,
      });
    });
  }

  Stream<User> getAuthStateChanges() {
    return auth.authStateChanges();
  }

  String getCurrentUserId() {
    if (auth.currentUser == null) return null;
    return auth.currentUser.uid;
  }

  Future<User> signIn(String email, String password) async {
    try {
      final result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (err) {
      print('(TRACE) Not authenticated: ${err.code}');
      return null;
    }
  }

  Future<void> signOut() {
    return auth.signOut();
  }

  Future<bool> isFcmAllowed(String deviceId) async {
    final uid = auth.currentUser.uid;
    final ref = store.collection('users').doc(uid).collection('devices').doc(deviceId);
    if (ref == null) return false;
    return ref.get().then((doc) => doc.data()['fcmToken'] != '' && doc.data()['fcmToken'] != null);
  }

  Future<String> getFcmToken(String deviceId) async {
    return fcm.getToken();
  }

  Future<void> deleteFcmToken(String deviceId) async {
    final uid = auth.currentUser.uid;
    final ref = store.collection('users').doc(uid).collection('devices').doc(deviceId);
    if (ref == null) return;
    await ref.set({
      'fcmToken': '',
    });
  }

  Future<void> saveFcmToken(String deviceId) async {
    final uid = auth.currentUser.uid;
    final fcmToken = await fcm.getToken();

    if (fcmToken != null) {
      final ref = store.collection('users').doc(uid).collection('devices').doc(deviceId);
      if (ref != null) {
        await ref.set({
          'fcmToken': fcmToken,
        });
      }
    }
  }
}
