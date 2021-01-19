import '../models/sensor_model.dart';
import '../models/diagram_control_model.dart';

import 'mock_service.dart';

class DiagramService {
  DiagramOptions _options;
  final Mocker mocker = Mocker();

  DiagramService();

  DiagramOptions getInitialOptions(String id, [Sensor sensor]) {
    _options = DiagramOptions(
      sensorId: id,
      activeToggle: 0,
      diagrams: [
        DiagramControl(
          type: 'CO2',
          unit: 'ppm',
          isExpanded: true,
          interval: DiagramTimeInterval(
            from: DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 5) -
                DiagramTimeInterval.hour +
                1,
            to: DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 5),
            size: DiagramTimeInterval.hour,
          ),
          datapoints: <DataPoint>[],
          lowerBound: 0.0,
          upperBound: 3500.0,
          offset: 0.0,
        ),
        DiagramControl(
          type: 'Temperatur',
          unit: '°C',
          isExpanded: false,
          interval: DiagramTimeInterval(
            from: DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 5) -
                DiagramTimeInterval.hour +
                1,
            to: DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 5),
            size: DiagramTimeInterval.hour,
          ),
          datapoints: <DataPoint>[],
          lowerBound: 0.0,
          upperBound: 35.0,
          offset: 0.0,
        ),
        DiagramControl(
          type: 'Feuchtigkeit',
          unit: '%',
          isExpanded: false,
          interval: DiagramTimeInterval(
            from: DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 5) -
                DiagramTimeInterval.hour +
                1,
            to: DiagramTimeInterval.justifyToMinutes(DateTime.now().millisecondsSinceEpoch, 5),
            size: DiagramTimeInterval.hour,
          ),
          datapoints: <DataPoint>[],
          lowerBound: 0.0,
          upperBound: 100.0,
          offset: 0.0,
        ),
      ],
    );
    if (sensor != null) _options.diagrams.forEach((d) => d.datapoints = sensor.getDataPoints(d.type, d.interval));
    return _options;
  }

  List<DataPoint> getDataPoints(Sensor sensor, DiagramControl control) {
    if (sensor == null) return <DataPoint>[];
    return sensor.getDataPoints(control.type, control.interval);
  }

  DiagramOptions resizeInterval(Sensor sensor, DiagramOptions options, int index) {
    _options = DiagramOptions.resizeInterval(options, index);
    _options.diagrams.forEach((d) => d.datapoints = getDataPoints(sensor, d));
    return _options;
  }

  DiagramOptions scrollDiagram(Sensor sensor, DiagramControl control, String direction) {
    _options.diagrams.forEach((d) {
      if (d.type == control.type) {
        if (direction == 'forward') d.interval = DiagramTimeInterval.next(d.interval);
        if (direction == 'back') d.interval = DiagramTimeInterval.previous(d.interval);
        d.datapoints = getDataPoints(sensor, control);
      }
    });
    return _options;
  }

  DiagramOptions toggleDiagramExpansion(DiagramControl control) {
    _options.diagrams.forEach((d) {
      if (d.type == control.type) {
        d.isExpanded = !d.isExpanded;
      }
    });
    return _options;
  }
}
