import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/ui/common/widgets/time_variable_widget/time_variable_widget_wm.dart';
import 'package:mwwm/mwwm.dart';
import 'package:mind_calc/ui/common/widgets/time_variable_widget/di/time_variable_widget_component.dart';

TimeVariableWidgetModel createTimeVariableWidgetWm(BuildContext context) {
  final component = Injector.of<TimeVariableWidgetComponent>(context).component;
  final dependencies = WidgetModelDependencies();
  return TimeVariableWidgetModel(dependencies);
}
