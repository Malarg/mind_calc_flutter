import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:mind_calc/domain/locale/loc_delegate.dart';
import 'package:mind_calc/ui/app/app_wm.dart';
import 'package:mind_calc/ui/app/di/app.dart';
import 'package:mind_calc/ui/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

import 'di/app_wm_builder.dart';

class App extends MwwmWidget<AppComponent> {
  App({
    Key key,
    WidgetModelBuilder wmBuilder = createAppWm,
  }) : super(
          key: key,
          dependenciesBuilder: (_) => AppComponent(),
          widgetStateBuilder: () => _AppState(),
          widgetModelBuilder: createAppWm,
        );
}

class _AppState extends WidgetState<AppWidgetModel> {
  GlobalKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    _navigatorKey = Injector.of<AppComponent>(context).component.navigatorKey;
    _initPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        localizationsDelegates: [const LocDelegate()],
        home: MainScreen());
  }

  void _initPrefs() {
    SharedPreferences.getInstance().then((prefs) {
      void _initIntPref(String prefName) {
        if (prefs.getInt(prefName) == null) {
          prefs.setInt(prefName, 0);
        }
      }

      _initIntPref(PrefsValues.calcPlusCount);
      _initIntPref(PrefsValues.calcMinusCount);
      _initIntPref(PrefsValues.calcMultiplyCount);
      _initIntPref(PrefsValues.calcDivideCount);
      _initIntPref(PrefsValues.calcPowCount);
      _initIntPref(PrefsValues.calcPercentCount);
    });
  }
}
