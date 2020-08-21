import 'package:flutter/material.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/pause/di/pause_screen_wm_builder.dart';
import 'package:mind_calc/ui/pause/pause_screen_wm.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'di/pause_screen_component.dart';

class PauseScreen extends MwwmWidget<PauseScreenComponent> {
  PauseScreen(
    Training training,
      {Key key,
      WidgetModelBuilder wmBuilder = createPauseScreenWm})
      : super(
            key: key,
            dependenciesBuilder: (context) => PauseScreenComponent(context, training),
            widgetStateBuilder: () => _PauseScreenState(),
            widgetModelBuilder: wmBuilder);
}

class _PauseScreenState extends WidgetState<PauseScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      key: wm.scaffoldKey,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Text(
              loc.main.pause,
              style: TextStyle(
                fontSize: 24,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 56,
              height: 56,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: ProjectColors.salmonPink,
                onPressed: () {
                  wm.playClickedAction.accept();
                },
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              height: 56,
              width: double.infinity,
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: ProjectColors.salmonPink,
                  onPressed: () {
                    wm.finishClickedAction.accept();
                  },
                  child: Text(
                    loc.main.finishTraining,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
