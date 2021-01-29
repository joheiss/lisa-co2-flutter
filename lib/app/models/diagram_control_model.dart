import 'package:intl/intl.dart';
import 'package:jo_tb_fl_chart/chart_controller_rx.dart';

class DiagramControl {
  final String type;
  final String unit;
  bool isExpanded;
  JOChartControllerRx controller;

  DiagramControl({this.type, this.unit, this.isExpanded, this.controller});
}

class DiagramOptions {
  final String sensorId;
  int activeToggle;
  final List<DiagramControl> diagrams;

  DiagramOptions({this.sensorId, this.activeToggle, this.diagrams});
}
