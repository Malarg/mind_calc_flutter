import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart' show NavigatorState;
import 'package:get_storage/get_storage.dart';
import 'package:mind_calc/data/db/db_provider.dart';
import 'package:mind_calc/data/models/calculation.dart';
import 'package:mind_calc/data/models/complexity.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:mind_calc/domain/calculation/calculation_provider.dart';
import 'package:mind_calc/ui/common/ads/ad_manager.dart';
import 'package:mind_calc/ui/pause/pause_screen_route.dart';
import 'package:mind_calc/ui/training/training_session_handler.dart';
import 'package:mind_calc/ui/training_result/training_result_screen_route.dart';
import 'package:mwwm/mwwm.dart';
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
  Database db;
  int _correctAnswersChainLenght = 0;
  Training training;
  TrainingSessionHandler trainingSessionHandler;
  DateTime _lastCalculationCompleted;
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

  InterstitialAd _interstitialAd;

  TrainingScreenWidgetModel(
      WidgetModelDependencies baseDependencies, this._type, this._navigator)
      : super(baseDependencies);

  @override
  void onLoad() async {
    _insertTraining();
    _calculationProvider = CalculationProvider();
    _createComplexityIfNeed();
    _generateCalc();
          MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
        keywords: <String>['flutterio', 'beautiful apps'],
        contentUrl: 'https://flutter.io',
        childDirected: false,
        testDevices: <
            String>[], // Android emulators are considered test devices
      );
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
    _interstitialAd.load();
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
        _showAdIfNeed();
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

  @override
  void dispose() {
    super.dispose();
    _interstitialAd.dispose();
  }

  void _insertTraining() async {
    var typeDb = await DBProvider.db.getTrainingTypesByValue(_type.value);
    var lastComplexity = await DBProvider.db.getLastComplexity();
    _lastCalculationCompleted = DateTime.now();
    training = await DBProvider.db.insertTraining(Training(
        null, typeDb, false, DateTime.now(), lastComplexity.value, Duration()));
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

    int currentComplexity = GetStorage().read(PrefsValues.complexity);
    if (isCalculationCorrect) {
      _correctAnswersChainLenght++;
      if (_correctAnswersChainLenght >= 3) {
        var inSecondsTime = _lastCalculationCompleted
            .difference(DateTime.now())
            .inSeconds
            .abs();
        if (inSecondsTime <= 10) {
          var newComplexity = currentComplexity + 1;
          GetStorage().write(PrefsValues.complexity, newComplexity);
          DBProvider.db.insertComplexity(
              Complexity(null, newComplexity, DateTime.now()));
        }
      }
    } else {
      _correctAnswersChainLenght = 0;
      var newComplexity = max(currentComplexity - 1, 1);
      DBProvider.db
          .insertComplexity(Complexity(null, newComplexity, DateTime.now()));
      GetStorage().write(PrefsValues.complexity, newComplexity);
    }
    _lastCalculationCompleted = DateTime.now();
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
        .getCalculation(GetStorage().read(PrefsValues.complexity));
    calculationState.accept(calc);
  }

  void _createComplexityIfNeed() {
    int currentComplexity;
    if (GetStorage().hasData(PrefsValues.complexity)) {
      currentComplexity = GetStorage().read(PrefsValues.complexity);
    } else {
      currentComplexity = 1;
      GetStorage().write(PrefsValues.complexity, currentComplexity);
    }
  }

  void _showAdIfNeed() async {
    var trainings = await DBProvider.db.getTrainings();
    var shouldShowAd =
        trainings.length > 10 && !GetStorage().read(PrefsValues.isProPurchaced);
    if (shouldShowAd) {
      _interstitialAd
        ..show(
          anchorType: AnchorType.bottom,
          anchorOffset: 0.0,
          horizontalCenterOffset: 0.0,
        );
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
