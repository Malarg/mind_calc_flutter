import 'dart:io';

import 'package:mind_calc/data/models/calculation.dart';
import 'package:mind_calc/data/models/complexity.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/data/models/training_type.dart';
import 'package:mind_calc/ui/training/training_screen_wm.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "calc_db.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Calculation ("
          "id INTEGER PRIMARY KEY,"
          "timestamp INTEGER,"
          "value TEXT,"
          "answer TEXT,"
          "result TEXT,"
          "trainingId INTEGER"
          ")");
      await db.execute("CREATE TABLE Training ("
          "id INTEGER PRIMARY KEY,"
          "isFinished INTEGER,"
          "startTime INTEGER,"
          "startComplexity INTEGER,"
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
      
      var complexity = Complexity(null, 1, DateTime.now());
      db.insert("Complexity", complexity.toMap());
    });
  }

  Future<List<TrainingType>> getTrainingTypes() async {
    List<Map<String, dynamic>> maps = await _database.query("TrainingType");
    return List.generate(maps.length, (i) {
      return TrainingType(
        maps[i]["id"],
        TrainingTypeEnum.fromString(maps[i]["value"]),
      );
    });
  }

  Future<TrainingType> getTrainingTypesByValue(String value) async {
    List<Map<String, dynamic>> maps = await _database
        .query("TrainingType", where: "value = ?", whereArgs: [value]);
    var map = maps.first;
    return TrainingType(
      map["id"],
      TrainingTypeEnum.fromString(map["value"]),
    );
  }

  Future<Calculation> insertCalculation(Calculation calculation) async {
    var id = await _database.insert("Calculation", calculation.toMap());
    calculation.id = id;
    return calculation;
  }

  Future<List<Calculation>> getCalculationsByTrainingId(int trainingId) async {
    List<Map<String, dynamic>> maps = await _database.query(
      "Calculation",
      where: "trainingId = ?",
      whereArgs: [trainingId],
    );
    var training = await getTrainingById(trainingId);
    return List.generate(maps.length, (i) {
      var map = maps[i];
      return Calculation(
          id: map["id"],
          training: training,
          timestamp: DateTime.fromMillisecondsSinceEpoch(map["timestamp"]),
          value: map["value"],
          result: map["result"],
          answer: map["answer"]);
    });
  }

  Future<Training> insertTraining(Training training) async {
    var id = await _database.insert("Training", training.toMap());
    training.id = id;
    return training;
  }

  Future<Training> updateTraining(Training training) async {
    await _database.update("Training", training.toMap(),
        where: "id = ?", whereArgs: [training.id]);
    return training;
  }

  Future<List<Training>> getTrainings() async {
    List<Map<String, dynamic>> maps = await _database.query("Training");
    var trainingTypes = await getTrainingTypes();
    return List.generate(maps.length, (i) {
      return _getTrainingByMap(maps[i], trainingTypes);
    });
  }

  Future<Training> getLastTraining() async {
    List<Training> trainings = await getTrainings();
    trainings.sort((a, b) => a.duration.compareTo(b.duration));
    return trainings.last;
  }

  Future<Training> getTrainingById(int id) async {
    var trainingTypes = await getTrainingTypes();
    List<Map<String, dynamic>> maps = await _database.query(
      "Training",
      where: "id = ?",
      whereArgs: [id],
    );
    var map = maps.first;
    return _getTrainingByMap(map, trainingTypes);
  }

  Future<Complexity> getLastComplexity() async {
    var map = (await _database.rawQuery('''SELECT *
        FROM Complexity
        ORDER BY id DESC
        LIMIT 1''')).first;
    return Complexity(
      map["id"],
      map["value"],
      DateTime.fromMillisecondsSinceEpoch(map["timestamp"]),
    );
  }

  Future<Complexity> insertComplexity(Complexity complexity) async {
    var id = await _database.insert("Complexity", complexity.toMap());
    complexity.id = id;
    return complexity;
  }

  Training _getTrainingByMap(
      Map<String, dynamic> map, List<TrainingType> trainingTypes) {
    var trainingType = trainingTypes.firstWhere((e) => e.id == map["typeId"]);
    var isFinished = map["isfinished"] == 1;
    var startTime = DateTime.fromMillisecondsSinceEpoch(map["startTime"]);
    var startComplexity = map["startComplexity"];
    var duration = Duration(milliseconds: map["duration"]);
    return Training(
      map["id"],
      trainingType,
      isFinished,
      startTime,
      startComplexity,
      duration,
    );
  }
}
