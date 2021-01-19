import 'local_ids_service.dart';
import '../services/sensor_service.dart';
import '../models/sensor_model.dart';
import '../models/diagram_control_model.dart';
import 'diagram_service.dart';

class Repository {
  DiagramService _diagramService;
  LocalIdsService _localIdsService;
  SensorService _sensorService;

  Repository(String serviceUrl) {
    print('(TRACE) Repository serviceUrl: $serviceUrl');
    _diagramService = DiagramService();
    _localIdsService = LocalIdsService();
    _sensorService = SensorService(serviceUrl);
  }

  Future<int> addSensorId(id) async {
    return _localIdsService.addSensorId(id);
  }

  Future<Sensor> addSensor(Sensor sensor) async {
    return _sensorService.addOne(sensor);
  }

  Future<Sensor> updateSensor(Sensor sensor) async {
    return _sensorService.updateOne(sensor);
  }

  Future<void> clearCache() async {}

  Future<void> deleteSensorId(String id) async {
    return _localIdsService.deleteSensorId(id);
  }

  Future<List<String>> fetchSensorIds() async {
    return _localIdsService.fetchSensorIds();
  }

  Future<Sensor> fetchSensor(String id) async {
    return _sensorService.fetchOne(id);
  }

  DiagramOptions getInitialDiagramOptions(String id, [Sensor sensor]) {
    return _diagramService.getInitialOptions(id, sensor);
  }

  DiagramOptions resizeInterval(Sensor sensor, DiagramOptions options, int index) {
    return _diagramService.resizeInterval(sensor, options, index);
  }

  DiagramOptions scrollDiagram(Sensor sensor, DiagramControl control, String direction) {
    return _diagramService.scrollDiagram(sensor, control, direction);
  }

  DiagramOptions toggleDiagramExpansion(DiagramControl control) {
    return _diagramService.toggleDiagramExpansion(control);
  }
}
