import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/ui/common/dialog/default_dialog_controller.dart';

class PauseScreenComponent implements Component {
  NavigatorState navigator;
  DefaultDialogController dialogController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Training training;

  PauseScreenComponent(BuildContext context, this.training) {
    dialogController = DefaultDialogController(scaffoldKey);
    navigator = Navigator.of(context);
  }
}
