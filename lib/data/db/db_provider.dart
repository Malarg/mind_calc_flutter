import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "calc_db.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Calculation ("
          "id INTEGER PRIMARY KEY,"
          "timestamp INTEGER,"
          "value TEXT,"
          "answer INTEGER,"
          "result INTEGER,"
          "trainingId INTEGER"
          ")");
      await db.execute("CREATE TABLE Training ("
          "id INTEGER PRIMARY KEY,"
          "finished INTEGER,"
          "startTime INTEGER,"
          "duration INTEGER,"
          "typeId INTEGER"
          ")");
      await db.execute("CREATE TABLE TrainingType ("
          "id INTEGER PRIMARY KEY,"
          "value TEXT"
          ")");
      await db.execute("CREATE TABLE Complexity ("
          "id INTEGER PRIMARY KEY,"
          "value INTEGER,"
          "timestamp INTEGER"
          ")");
      await db.rawInsert(
          "INSERT Into TrainingType (id,value)"
          "VALUES(?,?)",
          [1, "QUALITY"]);
      await db.rawInsert(
          "INSERT Into TrainingType (id,value)"
          "VALUES(?,?)",
          [2, "SPEED"]);
      await db.rawInsert(
          "INSERT Into TrainingType (id,value)"
          "VALUES(?,?)",
          [3, "ZEN"]);
    });
  }
}
