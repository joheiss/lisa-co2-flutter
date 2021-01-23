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
  static final version = '1.0.0';
  static String deviceId;
  static Future<void> getDeviceId() async {
    final _deviceService = locator<DeviceService>();
    Bloc.deviceId = await _deviceService.getDeviceId();
  }

  final Repository _repository = Repository();

  // final _sensorIds = PublishSubject<List<String>>();
  // final _sensorId = PublishSubject<String>();
  // final _sensors = BehaviorSubject<Map<String, Future<Sensor>>>();
  final _newSensor = BehaviorSubject<Sensor>();
  final _options = BehaviorSubject<DiagramOptions>();

  User _user;

  Bloc() {
    final pushNotificationService = PushNotificationService();
    pushNotificationService.init();
    FirebaseAuth.instance.authStateChanges().listen((User user) => _user = user);
  }

  User get user => _user;

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

  Future<void> addSensorId(String id) async {
    return _repository.addSensorId(id);
  }

  Future<void> deleteSensorId(String id) async {
    await _repository.deleteSensorId(id);
  }

  Future<void> updateSensor(Sensor sensor) async {
    return _repository.updateSensor(sensor);
  }

  void resizeDiagram(Sensor sensor, DiagramOptions diagramOptions, int index) {
    final options = _repository.resizeInterval(sensor, diagramOptions, index);
    _options.add(options);
  }

  void scrollDiagram(Sensor sensor, DiagramControl control, String direction) {
    DiagramOptions options = _repository.scrollDiagram(sensor, control, direction);
    _options.add(options);
  }

  void toggleDiagramExpansion(DiagramControl control) {
    DiagramOptions options = _repository.toggleDiagramExpansion(control);
    _options.add(options);
  }

  void dispose() {
    // _sensorIds.close();
    // _sensorId.close();
    // _sensors.close();
    _newSensor.close();
    _options.close();
  }
}

final bloc = Bloc();
