import 'package:flutter/material.dart' hide DayPeriod;
import 'package:mind_calc/generated/locale_base.dart';
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
          dependenciesBuilder: (context) => GoodDayWidgetComponent(context),
          widgetStateBuilder: () => _GoodDayWidgetState(),
          widgetModelBuilder: wmBuilder,
        );
}

///Состояние виджета пожелания доброго времени суток
class _GoodDayWidgetState extends WidgetState<GoodDayWidgetModel> {
  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder(
      streamedState: wm.dayPeriodState,
      builder: (BuildContext context, DayPeriod period) {
        return Text(
          _getDayPeriodString(period),
          style: TextStyle(
            fontSize: 25,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }

  String _getDayPeriodString(DayPeriod period) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    switch (period) {
      case DayPeriod.MORNING:
        return loc.main.goodMorning;
      case DayPeriod.AFTERNOON:
        return loc.main.goodAfternoon;
      case DayPeriod.EVENING:
        return loc.main.goodEvening;
      default:
        return loc.main.goodNight;
    }
  }
}
