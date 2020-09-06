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
  String get pause => _data["pause"];
  String get finishTraining => _data["finishTraining"];
  String get areYouSureToEndTraining => _data["areYouSureToEndTraining"];
  String get yes => _data["yes"];
  String get no => _data["no"];
  String get trainingFinished => _data["trainingFinished"];
  String get time => _data["time"];
  String get history => _data["history"];
  String get today => _data["today"];
  String get yesterday => _data["yesterday"];
  String get january => _data["january"];
  String get february => _data["february"];
  String get march => _data["march"];
  String get april => _data["april"];
  String get may => _data["may"];
  String get june => _data["june"];
  String get july => _data["july"];
  String get august => _data["august"];
  String get september => _data["september"];
  String get october => _data["october"];
  String get november => _data["november"];
  String get december => _data["december"];
  String get settings => _data["settings"];
  String get language => _data["language"];
  String get russian => _data["russian"];
  String get change => _data["change"];
  String get complexityLevel => _data["complexityLevel"];
  String get notifications => _data["notifications"];
  String get remindTraining => _data["remindTraining"];
  String get allowedOperations => _data["allowedOperations"];
  String get getProVersion => _data["getProVersion"];
  String get shareFriends => _data["shareFriends"];
  String get equalityMode => _data["equalityMode"];
  String get selectLanguage => _data["selectLanguage"];
  String get english => _data["english"];
  String get levelInscreaseInfoMessage => _data["levelInscreaseInfoMessage"];
  String get levelDecreaseInfoMessage => _data["levelDecreaseInfoMessage"];
}
