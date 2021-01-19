import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' show Client;
import '../models/sensor_model.dart';

// final _rootUrl = 'https://sensors.jovisco.net/v1';
final _rootUrl = 'http://10.0.2.2:3000/v1';

class SensorService {
  String serviceUrl;
  Client client = Client();

  SensorService(this.serviceUrl);

  Future<Sensor> fetchOne(String id) async {
    try {
      final response = await client.get('$serviceUrl/sensors/$id');
      if (response.statusCode != 200) throw ('Sensor $id not found, statusCode: $response.statusCode');
      final parsed = json.decode(response.body);
      final sensor = Sensor.fromJSON(parsed);
      return sensor;
    } catch(err) {
      print('(ERROR) fetch sensor failed!');
      print(err);
      throw(err);
    }
  }

  Future<List<Sensor>> fetchAll() async {
    final response = await client.get('$serviceUrl/sensors');
    final parsedList = json.decode(response.body);
    final sensors = parsedList.map((s) => Sensor.fromJSON(s));
    return sensors;
  }

  Future<Sensor> addOne(Sensor sensor) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await client.post(
      '$serviceUrl/sensors',
      headers: headers,
      body: jsonEncode(sensor.toMap()),
    );
    if (response.statusCode == 201) {
      final sensor = Sensor.fromJSON(jsonDecode(response.body));
      return sensor;
    }
    throw ('Failed to load sensor, statusCode: $response.statusCode');
  }

  Future<String> deleteOne(String id) async {
    final response = await client.delete('$serviceUrl/sensors/$id}');
    if (response.statusCode == 200) {
      return id;
    }
    throw Exception('Failed to delete sensor $id, statusCode: $response.statusCode');
  }

  Future<Sensor> updateOne(Sensor sensor) async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final response = await client.put(
      '$serviceUrl/sensors/${sensor.id}',
      headers: headers,
      body: jsonEncode(sensor.toMap()),
    );
    if (response.statusCode == 200) {
      final updated = Sensor.fromJSON(jsonDecode(response.body));
      return updated;
    }
    throw ('Failed to update sensor location ${sensor.id}, statusCode: $response.statusCode');
  }
}
