import 'package:jo_tb_fl_chart/chart_controller_rx.dart';

import '../models/sensor_model.dart';
import '../models/diagram_control_model.dart';

class DiagramService {
  DiagramOptions _options;

  static List<int> sizes = <int>[
    60 * 60 * 1000,
    6 * 60 * 60 * 1000,
    12 * 60 * 60 * 1000,
    24 * 60 * 60 * 1000,
    7 * 24 * 60 * 60 * 1000,
    30 * 24 * 60 * 60 * 1000,
  ];


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
        ),
        DiagramControl(
          type: 'Temperatur',
          unit: '°C',
          isExpanded: false,
        ),
        DiagramControl(
          type: 'Feuchtigkeit',
          unit: '%',
          isExpanded: false,
        ),
      ],
    );
    if (sensor != null) _options.diagrams.forEach((d) {
      List<JODataPoint> datapoints = sensor.measurements.map((m) =>
          JODataPoint(m.time, d.type == 'CO2' ? m.co2.toDouble() : d.type == 'Temperatur' ? m.temperature.toDouble() : m.humidity.toDouble())).toList();
      double upperBound = d.type == 'CO2' ? 3500.0 : d.type == 'Temperatur' ? 35.0 : 100.0;
      JOChartControllerRx controller = JOChartControllerRx(datapoints: datapoints, upperBound: upperBound);
      d.controller = controller;
    });
    return _options;
  }

  DiagramOptions resizeInterval(int selectedIndex) {
    _options.diagrams.forEach((d) => d.controller.size = sizes[selectedIndex]);
    _options.activeToggle = selectedIndex;
    return _options;
  }

  void scrollDiagram(DiagramControl control, direction) {
    control.controller.scrollDiagram(direction);
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
