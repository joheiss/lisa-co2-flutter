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

  static const int second = 1000;
  static const int minute = 60 * second;
  static const int hour = 60 * minute;
  static const int sixHours = 6 * hour;
  static const int twelveHours = 12 * hour;
  static const int day = 24 * hour;
  static const int week = 7 * day;
}
