import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:mwwm/mwwm.dart';
import 'package:flutter/widgets.dart' as w;
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences.getInstance().then((prefs) {
      void _initIntPref(String prefName, {int value = 0}) {
        if (prefs.getInt(prefName) == null) {
          prefs.setInt(prefName, value);
        }
      }

      void _initBoolPref(String prefName, bool value) {
        if (prefs.getBool(prefName) == null) {
          prefs.setBool(prefName, value);
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
    });
  }
}
