import 'package:flutter/material.dart' show NavigatorState;
import 'package:mind_calc/data/db/db_provider.dart';
import 'package:mind_calc/data/models/calculation.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/ui/main/main_screen_route.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:tuple/tuple.dart';

///Виджет модель экрана истории
class TrainingResultScreenWidgetModel extends WidgetModel {
  final Training _training;
  final NavigatorState _navigator;
  final StreamedState correctAnswersCountState = StreamedState<int>();
  final StreamedState wrongAnswersCountState = StreamedState<int>();
  final StreamedState calculationsState =
      StreamedState<Tuple2<Training, List<Calculation>>>();
  final StreamedState levelsInfoState = StreamedState<Tuple2<int, int>>();
  final Action continueAction = Action<void>();

  TrainingResultScreenWidgetModel(
      WidgetModelDependencies baseDependencies, this._training, this._navigator)
      : super(baseDependencies);

  @override
  void onLoad() {
    DBProvider.db
        .getCalculationsByTraining(_training)
        .then((calculations) {
      calculationsState
          .accept(Tuple2<Training, List<Calculation>>(_training, calculations));

      var correctAnswersCount =
          calculations.where((calc) => calc.answer == calc.result).length;
      correctAnswersCountState.accept(correctAnswersCount);

      var wrongAnswersCount = calculations.length - correctAnswersCount;
      wrongAnswersCountState.accept(wrongAnswersCount);
    });
    DBProvider.db.getLastComplexity().then((lastComplexity) {
      var startComplexity = _training.startComplexity;
      levelsInfoState.accept(Tuple2<int, int>(
        startComplexity,
        lastComplexity.value,
      ));
    });
    super.onLoad();
  }

  @override
  void onBind() {
    super.onBind();
    bind(continueAction, (t) {
      _navigator.pushAndRemoveUntil(
        MainScreenRoute(),
        (route) => false,
      );
    });
  }
}
