import 'package:mind_calc/data/db/db_provider.dart';
import 'package:mind_calc/data/models/calculation.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:tuple/tuple.dart';

/// [CalculationsHistoryWidgetModel] для [CalculationsHistory]
class CalculationsHistoryWidgetModel extends WidgetModel {
  final NavigatorState _navigator;
  Training _training;

  final StreamedState calculationsState =
      StreamedState<Tuple2<Training, List<Calculation>>>();

  final Action<void> backClickedAction = Action<void>();

  CalculationsHistoryWidgetModel(
    WidgetModelDependencies dependencies,
    this._navigator,
    this._training,
  ) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    DBProvider.db
        .getCalculationsByTraining(_training)
        .then((calculations) {
      calculationsState
          .accept(Tuple2<Training, List<Calculation>>(_training, calculations));
    });
  }

  @override
  void onBind() {
    super.onBind();

    bind(backClickedAction, (_) {
      _navigator.pop();
     });
  }
}
