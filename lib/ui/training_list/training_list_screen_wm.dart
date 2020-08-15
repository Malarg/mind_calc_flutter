import 'package:flutter/material.dart';
import 'package:mind_calc/ui/training/training_screen_route.dart';
import 'package:mind_calc/ui/training/training_screen_wm.dart';
import 'package:mwwm/mwwm.dart';

///Виджет модель виджета списка тренировок
class TrainingListScreenWidgetModel extends WidgetModel {

  final NavigatorState _navigator;

  TrainingListScreenWidgetModel(WidgetModelDependencies baseDependencies, this._navigator)
      : super(baseDependencies);

  void navigateToTraining(TrainingType type) {
    _navigator.push(TrainingScreenRoute(type));
  }
}