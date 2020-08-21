import 'package:flutter/material.dart' hide Action;
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/common/dialog/alert/flutter_alert.dart';
import 'package:mind_calc/ui/common/dialog/default_dialog_controller.dart';
import 'package:mind_calc/ui/training_result/training_result_screen_route.dart';
import 'package:mwwm/mwwm.dart';
import 'package:path/path.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class PauseScreenWidgetModel extends WidgetModel {
  final NavigatorState _navigator;
  final DefaultDialogController _dialogController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Training training;

  final playClickedAction = Action<void>();
  final finishClickedAction = Action<Context>();

  PauseScreenWidgetModel(WidgetModelDependencies baseDependencies,
      this._navigator, this._dialogController, this.scaffoldKey, this.training)
      : super(baseDependencies);

  @override
  void onBind() {
    bind(playClickedAction, (event) {
      _navigator.pop();
    });
    bind(finishClickedAction, (event) {
      var loc =
          Localizations.of<LocaleBase>(scaffoldKey.currentContext, LocaleBase);
      _dialogController.showPlatformAlertDialog(
          title: loc.main.areYouSureToEndTraining,
          actions: [
            AlertAction(text: loc.main.no, onPressed: () {}),
            AlertAction(text: loc.main.yes, onPressed: () {
              _navigator.pushAndRemoveUntil(TrainingResultScreenRoute(training), (route) => false);
            }),
          ],
          barrierDismissible: true);
    });
    super.onBind();
  }
}
