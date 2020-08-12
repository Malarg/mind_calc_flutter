import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/ui/training/di/training_screen_component.dart';
import 'package:mwwm/mwwm.dart';

import '../training_screen_wm.dart';

TrainingScreenWidgetModel createTrainingScreenWm(BuildContext context) {
  final component = Injector.of<TrainingScreenComponent>(context).component;
  final dependencies = WidgetModelDependencies();

  return TrainingScreenWidgetModel(dependencies, component.type);
}
