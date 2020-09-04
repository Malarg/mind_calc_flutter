import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

/// [Component] для [SelectLanguage]
class SelectLanguageComponent implements Component {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  NavigatorState navigator;
  WidgetModelDependencies wmDependencies;
  BuildContext parentContext;

SelectLanguageComponent(BuildContext context) {

    navigator = Navigator.of(context);
    parentContext = context;
  }
}
