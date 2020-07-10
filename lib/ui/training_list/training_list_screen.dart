import 'package:flutter/material.dart';
import 'package:mind_calc/ui/common/widgets/good_day/good_day_widget.dart';
import 'package:mind_calc/ui/training_list/training_list_screen_wm.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:mind_calc/ui/training_list/di/training_list_screen_component.dart';

import 'di/training_list_screen_wm_builder.dart';

/// Виджет списка тренировок
class TrainingListScreen extends MwwmWidget<TrainingListScreenComponent> {
  TrainingListScreen({
    Key key,
    WidgetModelBuilder wmBuilder = createTrainingListScreenWm,
  }) : super(
          key: key,
          dependenciesBuilder: (context) =>
              TrainingListScreenComponent(context),
          widgetStateBuilder: () => _TrainingListScreenState(),
          widgetModelBuilder: wmBuilder,
        );
}

/// Состояние виджета списка тренировок
class _TrainingListScreenState
    extends WidgetState<TrainingListScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GoodDayWidget(),
    );
  }
}
