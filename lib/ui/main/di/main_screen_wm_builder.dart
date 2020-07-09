
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mwwm/mwwm.dart';
import 'package:mind_calc/ui/main/di/main_screen_component.dart';
import 'package:mind_calc/ui/main/main_screen_wm.dart';

MainScreenWidgetModel createMainScreenWm(BuildContext context) {

  final component = Injector.of<MainScreenComponent>(context).component;
  final dependencies = WidgetModelDependencies();

  return MainScreenWidgetModel(dependencies);
}