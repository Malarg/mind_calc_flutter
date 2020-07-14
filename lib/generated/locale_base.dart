import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LocaleBase {
  Map<String, dynamic> _data;
  String _path;
  Future<void> load(String path) async {
    _path = path;
    final strJson = await rootBundle.loadString(path);
    _data = jsonDecode(strJson);
    initAll();
  }
  
  Map<String, String> getData(String group) {
    return Map<String, String>.from(_data[group]);
  }

  String getPath() => _path;

  Localemain _main;
  Localemain get main => _main;

  void initAll() {
    _main = Localemain(Map<String, String>.from(_data['main']));
  }
}

class Localemain {
  final Map<String, String> _data;
  Localemain(this._data);

  String get sample => _data["sample"];
  String get save => _data["save"];
  String get goodMorning => _data["goodMorning"];
  String get goodAfternoon => _data["goodAfternoon"];
  String get goodEvening => _data["goodEvening"];
  String get goodNight => _data["goodNight"];
  String get leaderboard => _data["leaderboard"];
  String get achievements => _data["achievements"];
  String get happyPractice => _data["happyPractice"];
  String get qualityTitle => _data["qualityTitle"];
  String get qualityDescription => _data["qualityDescription"];
  String get speedTitle => _data["speedTitle"];
  String get speedDescription => _data["speedDescription"];
  String get zenTitle => _data["zenTitle"];
  String get zenDescription => _data["zenDescription"];
}
