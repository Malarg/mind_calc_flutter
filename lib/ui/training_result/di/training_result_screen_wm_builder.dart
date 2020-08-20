import 'package:injector/injector.dart';
import 'package:flutter/widgets.dart';
import 'package:mwwm/mwwm.dart';
import 'package:mind_calc/ui/training_result/di/training_result_screen_component.dart';
import 'package:mind_calc/ui/training_result/training_result_screen_wm.dart';

TrainingResultScreenWidgetModel createTrainingResultScreenWm(
    BuildContext context) {
  final component =
      Injector.of<TrainingResultScreenComponent>(context).component;
  final dependencies = WidgetModelDependencies();
  final navigator = component.navigator;

  return TrainingResultScreenWidgetModel(
    dependencies,
    component.training,
    component.navigator,
  );
}
