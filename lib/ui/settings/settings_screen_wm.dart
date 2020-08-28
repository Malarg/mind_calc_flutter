import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import '../../data/resources/prefs_values.dart';

/// [SettingsWidgetModel] для [SettingsScreen]
class SettingsWidgetModel extends WidgetModel {
  final NavigatorState _navigator;
  SharedPreferences prefs;

  final StreamedState<int> complexityState = StreamedState(0);
  final StreamedState<bool> isComplexityEditModeState = StreamedState(false);

  final Action<void> showComplexityEditModeAction = Action();
  final Action<void> showComplexityDisplayModeAction = Action();

  final StreamedState<String> complexityTextFieldState = StreamedState("");
  final Action<String> complexityTextFieldChangedAction = Action();

  final StreamedState<bool> isMultiplyEnabledState = StreamedState();
  final StreamedState<bool> isDivideEnabledState = StreamedState();
  final StreamedState<bool> isPowEnabledState = StreamedState();
  final StreamedState<bool> isPercentEnabledState = StreamedState();

  final Action<void> multiplyButtonClickedAction = Action();
  final Action<void> divideButtonClickedAction = Action();
  final Action<void> powButtonClickedAction = Action();
  final Action<void> percentButtonClickedAction = Action();

  final StreamedState<bool> isEqualityModeEnabledState = StreamedState();
  final Action<bool> equalityModeChangedAction = Action();

  SettingsWidgetModel(
    WidgetModelDependencies dependencies,
    this._navigator,
  ) : super(dependencies);

  @override
  void onLoad() async {
    super.onLoad();
    prefs = await SharedPreferences.getInstance();
    int currentComplexity = prefs.getInt(PrefsValues.complexity);
    complexityState.accept(currentComplexity);
    complexityTextFieldState.accept(currentComplexity.toString());

    isMultiplyEnabledState.accept(prefs.getBool(PrefsValues.isMultiplyEnabled));
    isDivideEnabledState.accept(prefs.getBool(PrefsValues.isDivideEnabled));
    isPowEnabledState.accept(prefs.getBool(PrefsValues.isPowEnabled));
    isPercentEnabledState.accept(prefs.getBool(PrefsValues.isPercentEnabled));

    isEqualityModeEnabledState.accept(prefs.getBool(PrefsValues.isEqualityModeEnabled));
  }

  @override
  void onBind() {
    super.onBind();
    bind(showComplexityEditModeAction, (_) {
      isComplexityEditModeState.accept(true);
    });
    bind(showComplexityDisplayModeAction, (t) {
      isComplexityEditModeState.accept(false);
      if (complexityTextFieldChangedAction.value !=
          complexityTextFieldState.value) {
        var newComplexity = complexityTextFieldChangedAction.value != ""
            ? int.parse(complexityTextFieldChangedAction.value)
            : 1;
        complexityTextFieldState.accept(newComplexity.toString());
        complexityState.accept(newComplexity);
        prefs.setInt(PrefsValues.complexity, newComplexity);
      }
    });
    bind(equalityModeChangedAction, (value) {
      isEqualityModeEnabledState.accept(value);
      prefs.setBool(PrefsValues.isEqualityModeEnabled, value);
     });
    bind(multiplyButtonClickedAction, (t) {
      var newValue = !prefs.getBool(PrefsValues.isMultiplyEnabled);
      prefs.setBool(PrefsValues.isMultiplyEnabled, newValue);
      isMultiplyEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(divideButtonClickedAction, (t) {
      var newValue = !prefs.getBool(PrefsValues.isDivideEnabled);
      prefs.setBool(PrefsValues.isDivideEnabled, newValue);
      isDivideEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(powButtonClickedAction, (t) {
      var newValue = !prefs.getBool(PrefsValues.isPowEnabled);
      prefs.setBool(PrefsValues.isPowEnabled, newValue);
      isPowEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(percentButtonClickedAction, (t) {
      var newValue = !prefs.getBool(PrefsValues.isPercentEnabled);
      prefs.setBool(PrefsValues.isPercentEnabled, newValue);
      isPercentEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
  }

  _setZeroActionsCounters() {
    prefs.setInt(PrefsValues.calcPlusCount, 0);
    prefs.setInt(PrefsValues.calcMinusCount, 0);
    prefs.setInt(PrefsValues.calcMultiplyCount, 0);
    prefs.setInt(PrefsValues.calcDivideCount, 0);
    prefs.setInt(PrefsValues.calcPowCount, 0);
    prefs.setInt(PrefsValues.calcPercentCount, 0);
  }
}
