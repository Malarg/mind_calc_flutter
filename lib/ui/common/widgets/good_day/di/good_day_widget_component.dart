import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/app/di/app.dart';

///Компонент виджета пожелания доброго времени суток
class GoodDayWidgetComponent implements Component {

  LocaleBase stringsProvider;

  GoodDayWidgetComponent(BuildContext context) {
    var parentComponent = Injector.of<AppComponent>(context);

    stringsProvider = parentComponent.component.stringsProvider;
  }
}
