import 'package:get_storage/get_storage.dart';
import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:mwwm/mwwm.dart';
import 'package:flutter/widgets.dart' as w;

class AppWidgetModel extends WidgetModel {
  final w.GlobalKey<w.NavigatorState> _navigator;

  AppWidgetModel(WidgetModelDependencies baseDependencies, this._navigator)
      : super(baseDependencies);

  @override
  void onLoad() {
    _initPrefs();
    super.onLoad();
  }

  void _initPrefs() {
      void _initIntPref(String prefName, {int value = 0}) {
        if (GetStorage().read(prefName) == null) {
          GetStorage().write(prefName, value);
        }
      }

      void _initBoolPref(String prefName, bool value) {
        if (GetStorage().read(prefName) == null) {
          GetStorage().write(prefName, value);
        }
      }

      _initIntPref(PrefsValues.calcPlusCount);
      _initIntPref(PrefsValues.calcMinusCount);
      _initIntPref(PrefsValues.calcMultiplyCount);
      _initIntPref(PrefsValues.calcDivideCount);
      _initIntPref(PrefsValues.calcPowCount);
      _initIntPref(PrefsValues.calcPercentCount);

      _initIntPref(PrefsValues.complexity, value: 1);

      _initBoolPref(PrefsValues.isMultiplyEnabled, true);
      _initBoolPref(PrefsValues.isDivideEnabled, true);
      _initBoolPref(PrefsValues.isPowEnabled, false);
      _initBoolPref(PrefsValues.isPercentEnabled, false);

      _initBoolPref(PrefsValues.isEqualityModeEnabled, false);

      _initIntPref(PrefsValues.languageId, value: 1);

      _initBoolPref(PrefsValues.isProPurchaced, false);
  }
}
