
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class AppComponent implements Component {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  AppComponent() {
    rebuildDependencies();
  }

  void rebuildDependencies() {
    _initDependencies();
  }

  void _initDependencies() {
    
  }
}