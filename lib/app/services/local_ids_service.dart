import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalIdsService {
  Database db;
  final completer = Completer();
  Future get ready => completer.future;

  LocalIdsService() {
    _init().then((_) {
      completer.complete();
      return;
    });
  }

  Future _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'mysensors.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    // print('(TRACE) Db initialization is done ...');
  }

  void _createDb(Database newDb, int version) {
    newDb.execute("""
      CREATE TABLE MySensorIds
        (
          id TEXT PRIMARY KEY,
          time INTEGER
        )
    """);
  }

  Future<int> addSensorId(String id) async {
    final map = {'id': id, 'time': DateTime.now().millisecondsSinceEpoch};
    await ready;
    return db.insert('MySensorIds', map, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> clearSensorIds() async {
    await ready;
    return db.delete('MySensorIds');
  }

  Future<int> deleteSensorId(String id) async {
    await ready;
    return db.delete(
      'MySensorIds',
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<List<String>> fetchSensorIds() async {
    await ready;
    final maps = await db.query(
      'MySensorIds',
      columns: null,
      orderBy: 'time DESC',
    );
    // print('(TRACE) fetchSensorIds after query, ids found: ${maps.length}');

    // ### TESTING ###    // if (maps.length == 0) return null;
    // return maps.map((s) => s['id']).toList();

    List<String> ids = maps.map((s) => s['id'].toString()).toList();
    ids.forEach((i) => print(i));

    return <String>[
      ...ids,
      'abc-def-ghi-1',
      'abc-def-ghi-3',
      'abc-def-ghi-5',
      'abc-def-ghi-2',
      'abc-def-ghi-4',
      'abc-def-ghi-6',
    ];
  }
}
