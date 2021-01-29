import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../../service_locator.dart';
import '../models/sensor_model.dart';
import '../models/diagram_control_model.dart';
import 'diagram_service.dart';

class Repository {
  final DiagramService _diagramService = DiagramService();
  FirebaseService _firebaseService = locator<FirebaseService>();

  String getCurrentUserId() {
    return _firebaseService.getCurrentUserId();
  }

  Future<User> signIn(String email, String password) async {
    return _firebaseService.signIn(email, password);
  }

  Future<void> signOut() {
    return _firebaseService.signOut();
  }

  Future<bool> isNotificationAllowed(String deviceId) {
    return _firebaseService.isFcmAllowed(deviceId);
  }

  Future<void> allowNotifications(String deviceId) {
    return _firebaseService.saveFcmToken(deviceId);
  }

  Future<void> blockNotifications(String deviceId) {
    return _firebaseService.deleteFcmToken(deviceId);
  }

  Stream<QuerySnapshot> querySensorIds() {
    return _firebaseService.querySensorIds();
  }

  Stream<DocumentSnapshot> querySensor(id) {
    return _firebaseService.querySensor(id);
  }

  Stream<Sensor> querySensorWithAllMeasurements(id) {
    return _firebaseService.querySensorWithAllMeasurements(id);
  }

  Stream<Sensor> querySensorWithLastMeasurement(id) {
    return _firebaseService.querySensorWithLastMeasurement(id);
  }

  Future<void> addSensorId(id) async {
    return _firebaseService.createSensorId(id);
  }

  Future<void> deleteSensorId(String id) async {
    return _firebaseService.deleteSensorId(id);
  }

  Future<void> updateSensor(Sensor sensor) async {
    return _firebaseService.updateSensor(sensor);
  }

  DiagramOptions getInitialDiagramOptions(String id, [Sensor sensor]) {
    return _diagramService.getInitialOptions(id, sensor);
  }

  void scrollDiagram(DiagramControl control, String direction) {
    _diagramService.scrollDiagram(control, direction);
  }

  DiagramOptions resizeInterval(int index) {
    return _diagramService.resizeInterval(index);
  }

  DiagramOptions toggleDiagramExpansion(DiagramControl control) {
    return _diagramService.toggleDiagramExpansion(control);
  }
}
