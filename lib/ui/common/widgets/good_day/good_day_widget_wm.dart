import 'package:mwwm/mwwm.dart';
import 'package:surf_util/surf_util.dart';
import 'package:relation/relation.dart';

///Виджет модель виджета пожелания доброго времени суток
class GoodDayWidgetModel extends WidgetModel {
  final dayPeriodState = StreamedState<DayPeriod>(DayPeriod.NIGHT);

  GoodDayWidgetModel(
    WidgetModelDependencies baseDependencies,
  ) : super(baseDependencies) {
    dayPeriodState.accept(_getPeriod());
  }

  DayPeriod _getPeriod() {
    var hour = DateTime.now().hour;
    DayPeriod dayPeriod;

    if (hour >= 0 && hour < 6) {
      dayPeriod = DayPeriod.NIGHT;
    } else if (hour >= 6 && hour < 12) {
      dayPeriod = DayPeriod.MORNING;
    } else if (hour >= 12 && hour < 18) {
      dayPeriod = DayPeriod.AFTERNOON;
    } else {
      dayPeriod = DayPeriod.EVENING;
    }
    return dayPeriod;
  }
}

class DayPeriod extends Enum<String> {
  const DayPeriod(String value) : super(value);

  static const DayPeriod MORNING = DayPeriod("morning");
  static const DayPeriod AFTERNOON = DayPeriod("afternoon");
  static const DayPeriod EVENING = DayPeriod("evening");
  static const DayPeriod NIGHT = DayPeriod("night");
}
