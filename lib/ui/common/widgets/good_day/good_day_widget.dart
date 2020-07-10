import 'package:flutter/material.dart';
import 'package:mind_calc/ui/common/widgets/good_day/di/good_day_widget_wm_builder.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:mind_calc/ui/common/widgets/good_day/di/good_day_widget_component.dart';

import 'good_day_widget_wm.dart';

///Виджет пожелания доброго времени суток
class GoodDayWidget extends MwwmWidget<GoodDayWidgetComponent> {
  GoodDayWidget({
    Key key,
    WidgetModelBuilder wmBuilder = createGoodDayWidgetWm,
  }) : super(
          key: key,
          dependenciesBuilder: (context) => GoodDayWidgetComponent(),
          widgetStateBuilder: () => _GoodDayWidgetState(),
          widgetModelBuilder: wmBuilder,
        );
}

///Состояние виджета пожелания доброго времени суток
class _GoodDayWidgetState extends WidgetState<GoodDayWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Good day widget"),
    );
  }
}
