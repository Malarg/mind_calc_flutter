import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/ui/training_list/di/training_list_screen_component.dart';
import 'package:mwwm/mwwm.dart';
import '../training_list_screen_wm.dart';

TrainingListScreenWidgetModel createTrainingListScreenWm(BuildContext context) {
  final component = Injector.of<TrainingListScreenComponent>(context).component;
  final dependencies = WidgetModelDependencies();
  final navigator = component.navigator;

  return TrainingListScreenWidgetModel(dependencies, navigator);
}
