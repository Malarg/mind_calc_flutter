import 'package:calendar_time/calendar_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/history/history_screen_wm.dart';
import 'package:mind_calc/ui/training/training_screen_wm.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:tuple/tuple.dart';
import 'di/history_screen_component.dart';
import 'di/history_screen_wm_builder.dart';

///Экран истории
class HistoryScreen extends MwwmWidget<HistoryScreenComponent> {
  HistoryScreen({Key key, WidgetModelBuilder wmBuilder = createHistoryScreenWm})
      : super(
          key: key,
          dependenciesBuilder: (context) => HistoryScreenComponent(context),
          widgetStateBuilder: () => _HistoryScreenState(),
          widgetModelBuilder: wmBuilder,
        );
}

class _HistoryScreenState extends WidgetState<HistoryScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            loc.main.history,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ProjectColors.dusc,
              fontSize: 20,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: ProjectColors.iceBlue,
      ),
      backgroundColor: ProjectColors.iceBlue,
      body: StreamedStateBuilder(
        streamedState: wm.calculationsState,
        builder: (context, EntityState<List<Tuple2<Training, Tuple2<int, int>>>> trainings) {
          if (trainings.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (trainings.data.isEmpty) {
            return Center(child: Text("Нет тут ничего"),);
          }
          return SingleChildScrollView(
            child: Column(
              children: List.generate(trainings.data.length, (i) {
                var training = trainings.data[trainings.data.length - i - 1].item1;
                var trainingResult = trainings.data[trainings.data.length - i - 1].item2;
                var shouldShowDate = i == 0 ||
                    training.startTime.day !=
                        trainings.data[trainings.data.length - i].item1.startTime.day;
                return buildTrainingItem(
                  training,
                  trainingResult,
                  shouldShowDate,
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Widget buildTrainingItem(
    Training training,
    Tuple2<int, int> trainingResult,
    bool shouldShowDate,
  ) {
    var trainingType = getTrainingType(training);
    
    var hourString = training.startTime.hour.toString();
    hourString = hourString.length == 1 ? "0$hourString" : hourString;

    var minuteString = training.startTime.minute.toString();
    minuteString = minuteString.length == 1 ? "0$minuteString" : minuteString;

    return Column(
      children: <Widget>[
        if (shouldShowDate)
          SizedBox(
            height: 24,
          ),
        if (shouldShowDate) buildDate(training.startTime),
        if (shouldShowDate)
          SizedBox(
            height: 16,
          ),
        Container(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: FlatButton(
            color: Colors.white,
            onPressed: () {
              wm.trainingClickedAction.accept(training);
            },
            padding: EdgeInsets.fromLTRB(36, 8, 12, 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 80,
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$hourString:$minuteString",
                        style: TextStyle(
                          color: ProjectColors.coolGrey,
                          fontSize: 12,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        trainingType,
                        style: TextStyle(
                          color: ProjectColors.duscTwo,
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildResultChip(Icons.check, ProjectColors.ice,
                          trainingResult.item1.toString(),
                          textColor: ProjectColors.tealishGreen),
                      SizedBox(
                        height: 4,
                      ),
                      buildResultChip(Icons.close, ProjectColors.lightPink,
                          trainingResult.item2.toString(),
                          textColor: ProjectColors.neonRed)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

  Widget buildDate(DateTime date) {
    var dateString = getDateString(date);
    return Container(
      decoration: BoxDecoration(
        color: ProjectColors.greenBlue,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(
          dateString,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  String getDateString(DateTime date) {
    var calendarDate = CalendarTime(date);
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    String dateString;
    if (calendarDate.isToday) {
      dateString = loc.main.today;
    } else if (calendarDate.isYesterday) {
      dateString = loc.main.yesterday;
    } else {
      dateString = date.day.toString() + " ";
      switch (date.month) {
        case 1:
          {
            dateString += loc.main.january;
          }
          break;
        case 2:
          {
            dateString += loc.main.february;
          }
          break;
        case 3:
          {
            dateString += loc.main.march;
          }
          break;
        case 4:
          {
            dateString += loc.main.april;
          }
          break;
        case 5:
          {
            dateString += loc.main.may;
          }
          break;
        case 6:
          {
            dateString += loc.main.june;
          }
          break;
        case 7:
          {
            dateString += loc.main.july;
          }
          break;
        case 8:
          {
            dateString += loc.main.august;
          }
          break;
        case 9:
          {
            dateString += loc.main.september;
          }
          break;
        case 10:
          {
            dateString += loc.main.october;
          }
          break;
        case 11:
          {
            dateString += loc.main.november;
          }
          break;
        case 12:
          {
            dateString += loc.main.december;
          }
          break;
      }
    }
    if (date.year != DateTime.now().year) {
      dateString += " ${date.year}";
    }
    return dateString;
  }

  String getTrainingType(Training training) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    var trainingTypeString;
    switch (training.type.type) {
      case TrainingTypeEnum.QUALITY:
        {
          trainingTypeString = loc.main.qualityTitle;
        }
        break;
      case TrainingTypeEnum.SPEED:
        {
          trainingTypeString = loc.main.speedTitle;
        }
        break;
      case TrainingTypeEnum.ZEN:
        {
          trainingTypeString = loc.main.zenTitle;
        }
        break;
    }
    return trainingTypeString;
  }
}
