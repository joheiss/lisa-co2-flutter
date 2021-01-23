import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import '../services/push_notification_service.dart';
import '../../service_locator.dart';
import '../services/device_service.dart';
import '../services/localstorage_service.dart';
import '../services/repository.dart';
import '../models/sensor_model.dart';
import '../models/diagram_control_model.dart';

class Bloc {
  final _version = '1.0.0';
  final _deviceService = locator<DeviceService>();
  final _storageService = locator<LocalStorageService>();
  Repository _repository;
  String _deviceId;
  User _user;

  final _sensorIds = PublishSubject<List<String>>();
  final _sensorId = PublishSubject<String>();
  final _sensors = BehaviorSubject<Map<String, Future<Sensor>>>();
  final _newSensor = BehaviorSubject<Sensor>();

  final _options = BehaviorSubject<DiagramOptions>();

  Bloc() {
    print('(TRACE) service-url: $_storageService.serviceUrl');
    final pushNotificationService = PushNotificationService();
    pushNotificationService.init();
    FirebaseAuth.instance.authStateChanges().listen((User user) => _user = user);
    _getRepository();
    _sensorId.stream.transform(_sensorsTransformer()).pipe(_sensors);
  }

  Future<void> _getRepository() async {
    if (_deviceId == null) _deviceId = await _deviceService.getDeviceId();
    print('(TRACE) Devide Id: $_deviceId');
    _repository = Repository(_deviceId, _storageService.serviceUrl);
  }

  String get version => _version;
  User get user => _user;
  String get deviceId => _deviceId;
  set deviceId(String deviceId) {
    _deviceId = deviceId;
  }

  Stream<List<String>> get sensorIds => _sensorIds.stream;
  Stream<Map<String, Future<Sensor>>> get sensors => _sensors.stream;
  Function(String) get fetchSensor => _sensorId.add;

  Stream<Sensor> get newSensor => _newSensor.stream;
  Function(Sensor) get addSensor => _newSensor.add;

  Stream<DiagramOptions> get options => _options.stream;
  Function(DiagramOptions) get updateOptions => _options.add;

  Future<void> clearCache() async {
    return _repository.clearCache();
  }

  Future<void> getInitialOptions(String id, [Sensor sensor]) async {
    final options = _repository.getInitialDiagramOptions(id, sensor);
    _options.add(options);
  }

  Future<void> deleteSensorId(String id) async {
    // print('(TRACE) BLOC deleteSensorId $id ... from local database');
    await _repository.deleteSensorId(id);
    final ids = await _repository.fetchSensorIds();
    _sensorIds.add(ids);
  }

  Future<void> fetchSensorIds() async {
   // print('(TRACE) BLOC fetchSensorIds ... from local database');
    final ids = await _repository.fetchSensorIds();
    _sensorIds.add(ids);
  }

  ScanStreamTransformer<String, Map<String, Future<Sensor>>> _sensorsTransformer() {
    return ScanStreamTransformer(
      (Map<String, Future<Sensor>> cache, String id, int index) {
        cache[id] = _repository.fetchSensor(id);
        return cache;
      },
      <String, Future<Sensor>>{},
    );
  }

  Future<Sensor> fetchSensorById(String id) async {
    try {
      final sensor = await _repository.fetchSensor(id);
      await _repository.addSensorId(id);
      await _repository.fetchSensorIds();
      _newSensor.add(sensor);
      return sensor;
    } catch (err) {
      // sensor not found
      final toBeAdded = Sensor.fromBarcode(id);
      Sensor added = await _repository.addSensor(toBeAdded);
      _newSensor.add(added);
      return added;
    }
  }

  Future<Sensor> updateSensor(Sensor sensor) async {
    final updated = await _repository.updateSensor(sensor);
    if (updated.id == null) return null;
    await _repository.addSensorId(sensor.id);
    await _repository.fetchSensorIds();
    _newSensor.add(sensor);
    return updated;
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

  void changeSensor(Sensor sensor) {
    inspect(sensor);
    _newSensor.add(sensor);
  }

  void dispose() {
    _sensorIds.close();
    _sensorId.close();
    _sensors.close();
    _newSensor.close();
    _options.close();
  }
}

final bloc = Bloc();
