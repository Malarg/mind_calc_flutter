import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/ui/common/widgets/good_day/good_day_widget_wm.dart';
import 'package:mwwm/mwwm.dart';

import 'good_day_widget_component.dart';

GoodDayWidgetModel createGoodDayWidgetWm(BuildContext context) {
  final component = Injector.of<GoodDayWidgetComponent>(context).component;
  final dependencies = WidgetModelDependencies();

  return GoodDayWidgetModel(dependencies);
}
