import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'diagram_control_model.dart';

class SensorMeasurement {
  int time;
  int co2;
  int temperature;
  int humidity;

  SensorMeasurement(this.time, this.co2, this.temperature, this.humidity);

  SensorMeasurement.fromJSON(Map<String, dynamic> json)
      : time = json['time'].toDate().millisecondsSinceEpoch,
        co2 = json['co2'] ?? 0,
        temperature = json['temperature'] ?? 0,
        humidity = json['humidity'] ?? 0;
}

class Sensor {
  String id;
  String name;
  String description;
  String comment;
  List<SensorMeasurement> measurements;

  Sensor(this.id, [this.name, this.description, this.comment, this.measurements]);

  Sensor.fromBarcode(this.id) {
    this.name = this.description = this.comment = '';
    this.measurements = <SensorMeasurement>[];
  }

  Sensor.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    comment = json['comment'] ?? '';
    try {
        measurements = json['measurements'].map<SensorMeasurement>((m) => SensorMeasurement.fromJSON(m)).toList() ?? <SensorMeasurement>[];
    } on NoSuchMethodError {
      measurements = <SensorMeasurement>[];
    }
  }

  Sensor.fromFS(String id, Map<String, dynamic> json) {
    id = id;
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    comment = json['comment'] ?? '';
    try {
      measurements = json['measurements'].map<SensorMeasurement>((m) => SensorMeasurement.fromJSON(m)).toList() ?? <SensorMeasurement>[];
    } on NoSuchMethodError {
      measurements = <SensorMeasurement>[];
    }
  }

  Sensor.fromFSWithMeasurements(String id, Map<String, dynamic> json, List<SensorMeasurement> inputMeasurements) {
    id = id;
    name = json['name'] ?? '';
    description = json['description'] ?? '';
    comment = json['comment'] ?? '';
    try {
      measurements =  inputMeasurements.length > 0 ? inputMeasurements : <SensorMeasurement>[];
    } on NoSuchMethodError {
      measurements = <SensorMeasurement>[];
    }
  }

  Map<String, dynamic> toMap() {
    print(this.measurements);
    return {
      'id': id,
      'name': name,
      'description': description,
      'comment': comment,
      'measurements': measurements != null ? jsonEncode(measurements) : null,
    };
  }

  List<DataPoint> getDataPoints(String type, DiagramTimeInterval interval) {
    List<SensorMeasurement> ms = measurements.where((m) => m.time >= interval.from && m.time <= interval.to).toList();
    List<DataPoint> datapoints = DataPoint.buildFixedDataPoints(interval);
    int step = DataPoint.getStepSize(interval.size);
    datapoints.forEach((d) {
      List<SensorMeasurement> msInterval = ms.where((m) => d.time <= m.time && m.time <= d.time + step).toList();
      int value = 0;
      msInterval.forEach((m) {
        if (type == 'CO2') value += m.co2;
        if (type == 'Temperatur') value += m.temperature;
        if (type == 'Feuchtigkeit') value += m.humidity;
      });
      if (value > 0) value = value ~/ msInterval.length;
      d.value = value;
    });
    return datapoints;
  }

  static Icon mapStatusIcon(Sensor sensor, [DiagramControl control]) {
    int value;
    List<int> thresholds;
    int status = 0;

    if (control == null || control.type == 'CO2') {
      // CO2
      thresholds = <int>[0, 0, 0, 1500, 2500];
      value = sensor.measurements.length > 0 ? sensor.measurements[0].co2 : 0;
      int i = 0;
      thresholds.forEach((t) {
        if (i < 2 && value < t) max(status, status = 2 - i);
        if (i > 2 && value > t) max(status, status = i - 2);
        i++;
      });
    }
    if (control == null || control.type == 'Temperatur') {
      // Temperature
      thresholds = <int>[15, 18, 21, 24, 28];
      value = sensor.measurements.length > 0 ? sensor.measurements[0].temperature : 0;
      int i = 0;
      thresholds.forEach((t) {
        if (i < 2 && value < t) max(status, status = 2 - i);
        if (i > 2 && value > t) max(status, status = i - 2);
        i++;
      });
    }
    if (control == null || control.type == 'Feuchtigkeit') {
      // Humidity
      thresholds = <int>[35, 45, 55, 66, 75];
      value = sensor.measurements.length > 0 ? sensor.measurements[0].humidity : 0;
      int i = 0;
      thresholds.forEach((t) {
        if (i < 2 && value < t) max(status, status = 2 - i);
        if (i > 2 && value > t) max(status, status = i - 2);
        i++;
      });
    }
    if (status == 2) return Icon(Icons.error, color: Colors.red, size: 16.0);
    if (status == 1) return Icon(Icons.warning, color: Colors.yellow, size: 16.0);
    return Icon(Icons.check_circle, color: Colors.green, size: 16.0);
  }
}
