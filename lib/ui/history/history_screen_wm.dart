import 'dart:io';

import 'package:mind_calc/data/db/db_provider.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/ui/calculations_history/calculations_history_screen_route.dart';
import 'package:mwwm/mwwm.dart';
import 'package:pedantic/pedantic.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:tuple/tuple.dart';

///Вью модель экрана истории
class HistoryScreenWidgetModel extends WidgetModel {
  final NavigatorState _navigator;

  ///Лист тренировок и количество правильных и неправильных ответов в каждой
  final EntityStreamedState<List<Tuple2<Training, Tuple2<int, int>>>>
      calculationsState = EntityStreamedState();

  final Action<Training> trainingClickedAction = Action<Training>();
  HistoryScreenWidgetModel(
      WidgetModelDependencies baseDependencies, this._navigator)
      : super(baseDependencies);

  @override
  void onLoad() async {
    super.onLoad();
    calculationsState.loading();
    var trainings = await DBProvider.db.getTrainings();
    var allCalculations = await DBProvider.db.getCalculations();
    var trainingsWithAnswers = List<Tuple2<Training, Tuple2<int, int>>>();
    trainings.forEach((training) {
      var calculations = allCalculations.where((c) => c.training.id == training.id);
        if (calculations.isNotEmpty) {
          var correctAnswers =
              calculations.where((calc) => calc.answer == calc.result).length;
          var wrongAnswers = calculations.length - correctAnswers;
          trainingsWithAnswers.add(Tuple2<Training, Tuple2<int, int>>(
              training, Tuple2<int, int>(correctAnswers, wrongAnswers)));
        }
        unawaited(calculationsState.content(trainingsWithAnswers));
    });
    unawaited(calculationsState.content(trainingsWithAnswers));
  }

  @override
  void onBind() {
    super.onBind();

    bind(trainingClickedAction, (training) {
      _navigator.push(CalculationsHistoryScreenRoute(training));
    });
  }
}
