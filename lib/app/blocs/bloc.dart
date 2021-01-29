import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../services/push_notification_service.dart';
import '../../service_locator.dart';
import '../services/device_service.dart';
import '../services/repository.dart';
import '../models/sensor_model.dart';
import '../models/diagram_control_model.dart';

class Bloc {
  static final version = '1.0.2';
  static String deviceId;
  static Future<void> getDeviceId() async {
    final _deviceService = locator<DeviceService>();
    Bloc.deviceId = await _deviceService.getDeviceId();
  }

  final Repository _repository = Repository();

  final _fcmAllowed = BehaviorSubject<bool>();
  final _newSensor = BehaviorSubject<Sensor>();
  final _options = BehaviorSubject<DiagramOptions>();

  User _user;

  Bloc() {
    final pushNotificationService = PushNotificationService();
    pushNotificationService.init();
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      _user = user;
      await isNotificationAllowed();
    });
  }

  User get user => _user;

  Stream<bool> get fcmAllowed => _fcmAllowed.stream;

  Stream<Sensor> get newSensor => _newSensor.stream;
  Function(Sensor) get addSensor => _newSensor.add;

  Stream<DiagramOptions> get options => _options.stream;
  Function(DiagramOptions) get updateOptions => _options.add;

  String getCurrentUserId() {
    return _repository.getCurrentUserId();
  }

  Future<User> signIn(String email, String password) async {
    return _repository.signIn(email, password);
  }

  Future<void> signOut() {
    return _repository.signOut();
  }

  Future<bool> isNotificationAllowed() async {
    final allowed = await _repository.isNotificationAllowed(deviceId);
    _fcmAllowed.add(allowed);
    return allowed;
  }

  Future<void> allowNotifications() async {
    await _repository.allowNotifications(deviceId);
    _fcmAllowed.add(true);
  }

  Future<void> blockNotifications() async {
    await _repository.blockNotifications(deviceId);
    _fcmAllowed.add(false);
  }

  Future<void> getInitialOptions(String id, [Sensor sensor]) async {
    final options = _repository.getInitialDiagramOptions(id, sensor);
    _options.add(options);
  }

  Stream<QuerySnapshot> querySensorIds() {
    return _repository.querySensorIds();
  }

  Stream<DocumentSnapshot> querySensor(id) {
    return _repository.querySensor(id);
  }

  Stream<Sensor> querySensorWithAllMeasurements(id) {
    return _repository.querySensorWithAllMeasurements(id);
  }

  Stream<Sensor> querySensorWithLastMeasurement(id) {
    return _repository.querySensorWithLastMeasurement(id);
  }

  Future<void> addSensorId(String id) async {
    return _repository.addSensorId(id);
  }

  Future<void> deleteSensorId(String id) async {
    await _repository.deleteSensorId(id);
  }

  Future<void> updateSensor(Sensor sensor) async {
    return _repository.updateSensor(sensor);
  }

  void resizeDiagram(int index) {
    final options = _repository.resizeInterval(index);
    _options.add(options);
  }

  void scrollDiagram(DiagramControl control, String direction) {
    _repository.scrollDiagram(control, direction);
  }

  void toggleDiagramExpansion(DiagramControl control) {
    DiagramOptions options = _repository.toggleDiagramExpansion(control);
    _options.add(options);
  }

  void dispose() {
    _fcmAllowed.close();
    _newSensor.close();
    _options.close();
  }
}

final bloc = Bloc();
