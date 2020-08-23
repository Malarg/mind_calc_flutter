import 'package:flutter/widgets.dart';
import 'package:mind_calc/ui/history/di/history_screen_component.dart';
import 'package:mind_calc/ui/history/history_screen_wm.dart';
import 'package:injector/injector.dart';
import 'package:mwwm/mwwm.dart';

///Виджет модель экрана истории
HistoryScreenWidgetModel createHistoryScreenWm(BuildContext context) {
  final dependencies = WidgetModelDependencies();
  final component = Injector.of<HistoryScreenComponent>(context).component;
  final navigator = component.navigator;
  return HistoryScreenWidgetModel(dependencies, navigator);
}
