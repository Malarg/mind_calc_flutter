import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/ui/common/dialog/default_dialog_controller.dart';
import 'package:mwwm/mwwm.dart';

/// [Component] для [Settings]
class SettingsScreenComponent implements Component {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DialogController dialogController;
  NavigatorState navigator;
  WidgetModelDependencies wmDependencies;

SettingsScreenComponent(BuildContext context) {
    dialogController = DefaultDialogController(scaffoldKey);
    navigator = Navigator.of(context);
  }
}