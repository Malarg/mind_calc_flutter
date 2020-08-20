import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_calc/data/models/calculation.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/data/resources/assets.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/training/training_screen.dart';
import 'package:mind_calc/ui/training_result/di/training_result_screen_wm_builder.dart';
import 'package:mind_calc/ui/training_result/training_result_screen_wm.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'di/training_result_screen_component.dart';

class TrainingResultScreen extends MwwmWidget<TrainingResultScreenComponent> {
  TrainingResultScreen(Training training,
      {Key key, WidgetModelBuilder wmBuilder = createTrainingResultScreenWm})
      : super(
            key: key,
            dependenciesBuilder: (context) =>
                TrainingResultScreenComponent(context, training),
            widgetStateBuilder: () => _TrainingResultScreenState(),
            widgetModelBuilder: wmBuilder);
}

class _TrainingResultScreenState
    extends WidgetState<TrainingResultScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return WillPopScope(
      onWillPop: () {
        wm.continueAction.accept();
        return;
      },
      child: Scaffold(
        backgroundColor: ProjectColors.iceBlue,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 44),
              _buildContinueButton(),
              SizedBox(height: 88),
              Text(
                loc.main.trainingFinished,
                style: TextStyle(
                  color: ProjectColors.dusc,
                  fontSize: 25,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  StreamedStateBuilder(
                    streamedState: wm.correctAnswersCountState,
                    builder: (context, value) => buildResultChip(
                        Icons.check, ProjectColors.greenBlue, value.toString()),
                  ),
                  SizedBox(width: 16),
                  StreamedStateBuilder(
                    streamedState: wm.wrongAnswersCountState,
                    builder: (context, value) => buildResultChip(Icons.close,
                        ProjectColors.salmonPink, value.toString()),
                  ),
                  Expanded(
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.share,
                        color: Colors.black,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              StreamedStateBuilder(
                streamedState: wm.calculationsState,
                builder: (_, obj) {
                  var training = obj.item1 as Training;
                  var calcs = obj.item2 as List<Calculation>;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(calcs.length, (i) {
                      return buildHistoryCalc(
                        calcs[i],
                        i > 0 ? calcs[i - 1].timestamp : training.startTime,
                      );
                    }),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildResultChip(IconData icon, Color color, String value,
      {Color textColor = Colors.white}) {
    return Container(
      child: SizedBox(
        height: 32,
        width: 72,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Row(
              children: <Widget>[
                SizedBox(width: 8),
                Icon(
                  icon,
                  color: textColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 0.3,
                  child: Container(
                    color: ProjectColors.iceBlue,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHistoryCalc(Calculation calculation, DateTime prevTime) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    final duration =
        _stringifyDuration(calculation.timestamp.difference(prevTime));
    return Container(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: SizedBox(
            width: double.infinity,
            height: 56,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${loc.main.time}: $duration",
                        style: TextStyle(
                          color: ProjectColors.coolGrey,
                          fontSize: 12,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Expanded(
                          child: FittedBox(
                            child: CalculationText(
                              calculation.value,
                              calculation.answer,
                              answerBackgroundColor: ProjectColors.iceBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 24),
                calculation.answer == calculation.result
                    ? Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: ProjectColors.ice,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        child: Icon(
                          Icons.check,
                          color: ProjectColors.tealishGreen,
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                        decoration: BoxDecoration(
                          color: ProjectColors.lightPink,
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                        ),
                        child: Text(
                          calculation.result,
                          style: TextStyle(
                            color: ProjectColors.neonRed,
                            fontSize: 16,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      )
              ],
            )),
      ),
    );
  }

  Row _buildContinueButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Container(
          width: 56,
          height: 56,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: ProjectColors.warmBlue,
            onPressed: () {
              wm.continueAction.accept();
            },
            child: SvgPicture.asset(
              Assets.arrow_right,
              color: Colors.white,
              height: 24,
            ),
          ),
        ),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }

  String _stringifyDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMillis = twoDigits(duration.inMilliseconds.remainder(1000));
    return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMillis";
  }
}
