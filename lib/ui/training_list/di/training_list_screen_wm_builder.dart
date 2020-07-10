import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/ui/training_list/di/training_list_screen_component.dart';
import 'package:mwwm/mwwm.dart';
import 'package:mind_calc/ui/main/di/main_screen_component.dart';
import 'package:mind_calc/ui/main/main_screen_wm.dart';
import '../training_list_screen_wm.dart';

TrainingListScreenWidgetModel createTrainingListScreenWm(BuildContext context) {
  final component = Injector.of<TrainingListScreenComponent>(context).component;
  final dependencies = WidgetModelDependencies();

  return TrainingListScreenWidgetModel(dependencies);
}
