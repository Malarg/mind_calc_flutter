import 'package:mind_calc/ui/pause/di/pause_screen_component.dart';
import 'package:mind_calc/ui/pause/pause_screen_wm.dart';
import 'package:injector/injector.dart';
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';

PauseScreenWidgetModel createPauseScreenWm(BuildContext context) {
  final dependencies = WidgetModelDependencies();
  final component = Injector.of<PauseScreenComponent>(context).component;
  final navigator = component.navigator;
  final dialogController = component.dialogController;

  return PauseScreenWidgetModel(
      dependencies, navigator, dialogController, component.scaffoldKey);
}
