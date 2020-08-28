import 'package:flutter/material.dart';
import 'package:mind_calc/data/models/calculation.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/training/training_screen.dart';

///Итем вычисления с временем вычисления и правильным ответом
class CalculationHistoryItem extends StatelessWidget {
  final Calculation calculation;
  final DateTime prevTime;

  const CalculationHistoryItem({Key key, this.calculation, this.prevTime})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
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
                      SizedBox(height: 2,),
                      FittedBox(
                        child: CalculationText(
                          calculation.value,
                          calculation.answer,
                          answerBackgroundColor: ProjectColors.iceBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                    ),
            ],
          ),
        ),
      ),
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
