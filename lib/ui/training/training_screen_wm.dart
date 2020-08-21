import 'dart:math';

import 'package:flutter/material.dart' show NavigatorState;
import 'package:mind_calc/data/db/db_provider.dart';
import 'package:mind_calc/data/models/calculation.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:mind_calc/domain/calculation/calculation_provider.dart';
import 'package:mind_calc/ui/pause/pause_screen_route.dart';
import 'package:mind_calc/ui/training/training_session_handler.dart';
import 'package:mind_calc/ui/training_result/training_result_screen_route.dart';
import 'package:mwwm/mwwm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:surf_util/surf_util.dart';
import 'package:tuple/tuple.dart';

///Виджет экрана тренировки
class TrainingScreenWidgetModel extends WidgetModel {
  final NavigatorState _navigator;
  String _currentText = "";
  CalculationProvider _calculationProvider;
  TrainingTypeEnum _type;
  SharedPreferences prefs;
  Database db;
  int _correctAnswersChainLenght = 0;
  Training training;
  TrainingSessionHandler trainingSessionHandler;
  final isScreenHasBeenStartedState = StreamedState<bool>(false);
  final currentTextState = StreamedState<String>();
  final isLastCalculationCorrectState = StreamedState<bool>();
  final calculationState = StreamedState<Tuple2<String, int>>();
  final sessionTypeInfoState = StreamedState<String>();

  final addTextAction = Action<String>();
  final clearTextAction = Action<void>();
  final acceptTextAction = Action<void>();
  final startTimerHasBeenExpiredAction = Action<void>();
  final pauseClickedAction = Action<void>();

  TrainingScreenWidgetModel(
      WidgetModelDependencies baseDependencies, this._type, this._navigator)
      : super(baseDependencies);

  @override
  void onLoad() async {
    prefs = await SharedPreferences.getInstance();
    _insertTraining();
    _calculationProvider = CalculationProvider(prefs);
    _createComplexityIfNeed();
    _generateCalc();
    super.onLoad();
  }

  @override
  void onBind() {
    super.onBind();
    bind(addTextAction, (text) {
      _addText(text);
    });
    bind(clearTextAction, (event) {
      _clearText();
    });
    bind(acceptTextAction, (event) {
      _checkCalculation();
      _insertCalculationInDb();
      var isLastCalc =
          trainingSessionHandler.shouldFinishOnCalculationCompleted();
      if (!isLastCalc) {
        _clearText();
        _generateCalc();
      } else {
        _finishTrainingInDb().then((value) {
          _navigator.push(TrainingResultScreenRoute(value));
        });
      }
    });
    bind(startTimerHasBeenExpiredAction, (event) {
      trainingSessionHandler = TrainingSessionHandler(
        _type,
        (str) {
          sessionTypeInfoState.accept(str);
        },
      );
      isScreenHasBeenStartedState.accept(true);
    });
    bind(pauseClickedAction, (event) {
      trainingSessionHandler.pauseTimer();
      _navigator.push(PauseScreenRoute(training)).then((value) {
        trainingSessionHandler.resumeTimer();
      });
    });
  }

  void _insertTraining() async {
    var typeDb = await DBProvider.db.getTrainingTypesByValue(_type.value);
    training = await DBProvider.db.insertTraining(
        Training(null, typeDb, false, DateTime.now(), Duration()));
  }

  void _addText(String text) {
    _currentText += text;
    currentTextState.accept(_currentText);
  }

  void _clearText() {
    _currentText = "";
    currentTextState.accept(_currentText);
  }

  void _checkCalculation() {
    final isCalculationCorrect =
        _currentText == calculationState.value.item2.toString();
    isLastCalculationCorrectState.accept(isCalculationCorrect);

    int currentComplexity = prefs.getInt(PrefsValues.complexity);
    if (isCalculationCorrect) {
      _correctAnswersChainLenght++;
      if (_correctAnswersChainLenght >= 3) {
        prefs.setInt(PrefsValues.complexity, currentComplexity + 1);
      }
    } else {
      _correctAnswersChainLenght = 0;
      var newComplexity = max(currentComplexity - 1, 1);
      prefs.setInt(PrefsValues.complexity, newComplexity);
    }
  }

  void _insertCalculationInDb() async {
    var calculation = Calculation(
      id: null,
      training: training,
      timestamp: DateTime.now(),
      value: calculationState.value.item1,
      result: calculationState.value.item2.toString(),
      answer: _currentText,
    );
    await DBProvider.db.insertCalculation(calculation);
  }

  Future<Training> _finishTrainingInDb() async {
    training.isFinished = true;
    await DBProvider.db.updateTraining(training);
    return training;
  }

  void _generateCalc() {
    var calc = _calculationProvider
        .getCalculation(prefs.getInt(PrefsValues.complexity), true, [
      CalculationAction.PLUS,
      CalculationAction.MINUS,
      CalculationAction.MULTIPLY,
      CalculationAction.DIVIDE,
      CalculationAction.PERCENT,
      CalculationAction.POW,
    ]);
    calculationState.accept(calc);
  }

  void _createComplexityIfNeed() {
    int currentComplexity;
    if (prefs.containsKey(PrefsValues.complexity)) {
      currentComplexity = prefs.getInt(PrefsValues.complexity);
    } else {
      currentComplexity = 1;
      prefs.setInt(PrefsValues.complexity, currentComplexity);
    }
  }
}

class TrainingTypeEnum extends Enum<String> {
  static const String _quality = "QUALITY";
  static const String _speed = "SPEED";
  static const String _zen = "ZEN";
  const TrainingTypeEnum(String value) : super(value);
  static const TrainingTypeEnum QUALITY = TrainingTypeEnum(_quality);
  static const TrainingTypeEnum SPEED = TrainingTypeEnum(_speed);
  static const TrainingTypeEnum ZEN = TrainingTypeEnum(_zen);

  static TrainingTypeEnum fromString(String str) {
    switch (str) {
      case _quality:
        {
          return QUALITY;
        }
        break;
      case _speed:
        {
          return SPEED;
        }
        break;
      case _zen:
        {
          return ZEN;
        }
        break;
      default:
        {
          return ZEN;
        }
        break;
    }
  }
}
