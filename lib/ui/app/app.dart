import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/domain/locale/loc_delegate.dart';
import 'package:mind_calc/ui/app/app_wm.dart';
import 'package:mind_calc/ui/app/di/app.dart';
import 'package:mind_calc/ui/main/main_screen.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        localizationsDelegates: [const LocDelegate()],
        home: MainScreen());
  }
}
