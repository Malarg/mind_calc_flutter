import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/generated/locale_base.dart';

class AppComponent implements Component {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final LocaleBase stringsProvider = LocaleBase();

  AppComponent() {
    rebuildDependencies();
  }

  void rebuildDependencies() {
    _initDependencies();
  }

  void _initDependencies() {}
}
