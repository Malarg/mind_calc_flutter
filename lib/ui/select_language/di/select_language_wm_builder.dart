import 'package:mind_calc/ui/select_language/di/select_language_component.dart';
import '../select_language_screen_wm.dart';
import 'package:injector/injector.dart';
import 'package:mwwm/mwwm.dart';

SelectLanguageWidgetModel createSelectLanguageWm(context) {
  final component = Injector.of<SelectLanguageComponent>(context).component;
  return SelectLanguageWidgetModel(
    WidgetModelDependencies(),
    component.navigator,
    component.parentContext,
  );
}
