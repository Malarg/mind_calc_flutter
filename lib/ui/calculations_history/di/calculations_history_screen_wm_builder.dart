import 'package:injector/injector.dart';
import 'package:mwwm/mwwm.dart';
import '../calculations_history_screen_wm.dart';
import 'calculations_history_screen_component.dart';

CalculationsHistoryWidgetModel createCalculationsHistoryWm(context) {
  final component =
      Injector.of<CalculationsHistoryComponent>(context).component;
  return CalculationsHistoryWidgetModel(
      WidgetModelDependencies(), component.navigator, component.training);
}
