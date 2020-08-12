import 'dart:math';

import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:mind_calc/domain/calculation/calculation_provider.dart';
import 'package:mind_calc/ui/training/training_session_handler.dart';
import 'package:mwwm/mwwm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:tuple/tuple.dart';

///Виджет экрана тренировки
class TrainingScreenWidgetModel extends WidgetModel {
  String _currentText = "";
  CalculationProvider _calculationProvider;
  TrainingType _type;
  SharedPreferences prefs;
  int _correctAnswersChainLenght = 0;
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

  TrainingScreenWidgetModel(
      WidgetModelDependencies baseDependencies, this._type)
      : super(baseDependencies);

  @override
  void onLoad() async {
    prefs = await SharedPreferences.getInstance();
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
      var isLastCalc =
          trainingSessionHandler.shouldFinishOnCalculationCompleted();
      if (!isLastCalc) {
        _clearText();
        _generateCalc();
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

enum TrainingType { QUALITY, SPEED, ZEN }
