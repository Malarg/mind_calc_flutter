
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/ui/app/app_wm.dart';
import 'package:mind_calc/ui/app/di/app.dart';
import 'package:mwwm/mwwm.dart';

AppWidgetModel createAppWm(BuildContext context) {
  final component = Injector.of<AppComponent>(context).component;
  final dependencies = WidgetModelDependencies();

  return AppWidgetModel(dependencies, component.navigatorKey);
}