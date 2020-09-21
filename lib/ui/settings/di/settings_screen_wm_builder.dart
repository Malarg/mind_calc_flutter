import 'package:injector/injector.dart';
import 'package:mind_calc/ui/settings/di/settings_screen_component.dart';
import 'package:mind_calc/ui/settings/settings_screen_wm.dart';
import 'package:mwwm/mwwm.dart';

SettingsWidgetModel createSettingsScreenWm(context) {
  final component = Injector.of<SettingsScreenComponent>(context).component;
  return SettingsWidgetModel(
    WidgetModelDependencies(),
    component.navigator,
    component.dialogController
  );
}
