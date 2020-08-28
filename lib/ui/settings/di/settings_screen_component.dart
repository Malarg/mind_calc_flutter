import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mwwm/mwwm.dart';

/// [Component] для [Settings]
class SettingsScreenComponent implements Component {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  NavigatorState navigator;
  WidgetModelDependencies wmDependencies;

SettingsScreenComponent(BuildContext context) {
    navigator = Navigator.of(context);
  }
}