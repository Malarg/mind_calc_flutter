import 'package:flutter/material.dart' hide Action;
import 'package:get_storage/get_storage.dart';
import 'package:mind_calc/data/db/db_provider.dart';
import 'package:mind_calc/data/models/complexity.dart';
import 'package:mind_calc/ui/select_language/select_language_route.dart';
import 'package:mwwm/mwwm.dart';
import 'package:mind_calc/ui/select_language/select_language_screen_wm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import '../../data/resources/prefs_values.dart';

/// [SettingsWidgetModel] для [SettingsScreen]
class SettingsWidgetModel extends WidgetModel {
  final NavigatorState _navigator;

  final StreamedState<bool> isPremiumEnabledState = StreamedState(true);

  final Action<void> changeLanguageAction = Action();
  final StreamedState<int> languageState = StreamedState();

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

  final StreamedState<bool> isNotificationsEnabled = StreamedState();
  final Action<bool> notificationEnabledChangedAction = Action();

  SettingsWidgetModel(
    WidgetModelDependencies dependencies,
    this._navigator,
  ) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    var prefs = GetStorage();
    // final ProductDetailsResponse response = await InAppPurchaseConnection.instance.queryProductDetails({"pro_version"});
    // final bool isAvailable = await InAppPurchaseConnection.instance.isAvailable();
    languageState.accept(prefs.read(PrefsValues.languageId) ?? ENGLISH_ID);

    int currentComplexity = prefs.read(PrefsValues.complexity);
    complexityState.accept(currentComplexity);
    complexityTextFieldState.accept(currentComplexity.toString());

    isMultiplyEnabledState.accept(prefs.read(PrefsValues.isMultiplyEnabled));
    isDivideEnabledState.accept(prefs.read(PrefsValues.isDivideEnabled));
    isPowEnabledState.accept(prefs.read(PrefsValues.isPowEnabled));
    isPercentEnabledState.accept(prefs.read(PrefsValues.isPercentEnabled));

    isEqualityModeEnabledState.accept(prefs.read(PrefsValues.isEqualityModeEnabled));
  }

  @override
  void onBind() {
    super.onBind();
    bind(changeLanguageAction, (_) { 
      _navigator.push(SelectLanguageRoute()).then((_) {
        var langId = GetStorage().read(PrefsValues.languageId);
        languageState.accept(langId);
      });
    });
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
        GetStorage().write(PrefsValues.complexity, newComplexity);
        DBProvider.db
          .insertComplexity(Complexity(null, newComplexity, DateTime.now()));
      }
    });
    bind(notificationEnabledChangedAction, (value) {
      isNotificationsEnabled.accept(value);
    });
    bind(equalityModeChangedAction, (value) {
      isEqualityModeEnabledState.accept(value);
      GetStorage().write(PrefsValues.isEqualityModeEnabled, value);
     });
    bind(multiplyButtonClickedAction, (t) {
      var newValue = !GetStorage().read(PrefsValues.isMultiplyEnabled);
      GetStorage().write(PrefsValues.isMultiplyEnabled, newValue);
      isMultiplyEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(divideButtonClickedAction, (t) {
      var newValue = !GetStorage().read(PrefsValues.isDivideEnabled);
      GetStorage().write(PrefsValues.isDivideEnabled, newValue);
      isDivideEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(powButtonClickedAction, (t) {
      var newValue = !GetStorage().read(PrefsValues.isPowEnabled);
      GetStorage().write(PrefsValues.isPowEnabled, newValue);
      isPowEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(percentButtonClickedAction, (t) {
      var newValue = !GetStorage().read(PrefsValues.isPercentEnabled);
      GetStorage().write(PrefsValues.isPercentEnabled, newValue);
      isPercentEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
  }

  _setZeroActionsCounters() {
    GetStorage().write(PrefsValues.calcPlusCount, 0);
    GetStorage().write(PrefsValues.calcMinusCount, 0);
    GetStorage().write(PrefsValues.calcMultiplyCount, 0);
    GetStorage().write(PrefsValues.calcDivideCount, 0);
    GetStorage().write(PrefsValues.calcPowCount, 0);
    GetStorage().write(PrefsValues.calcPercentCount, 0);
  }
}
