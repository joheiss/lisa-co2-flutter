import 'dart:math';

import '../models/diagram_control_model.dart';

class Mocker {
  final _random = Random();
  int next(int min, int max) => min + _random.nextInt(max - min);

  List<DataPoint> fakeCo2Data() {
    final date = DateTime.now();
    int time = date.millisecondsSinceEpoch;
    List<DataPoint> datapoints = <DataPoint>[];
    for (var i = 0, t = time; i < 1000; i++, time -= 3 * 60 * 1000) {
      datapoints.add(DataPoint(t, next(600, 3500)));
    }
    return datapoints;
  }

  List<DataPoint> fakeTempData() {
    final date = DateTime.now();
    int time = date.millisecondsSinceEpoch;
    List<DataPoint> datapoints = <DataPoint>[];
    for (var i = 0, t = time; i < 1000; i++, time -= 3 * 60 * 1000) {
      datapoints.add(DataPoint(t, next(600, 3500)));
    }
    return datapoints;
  }

  List<DataPoint> fakeHumidityData() {
    final date = DateTime.now();
    int time = date.millisecondsSinceEpoch;
    List<DataPoint> datapoints = <DataPoint>[];
    for (var i = 0, t = time; i < 1000; i++, time -= 3 * 60 * 1000) {
      datapoints.add(DataPoint(t, next(600, 3500)));
    }
    return datapoints;
  }
}
