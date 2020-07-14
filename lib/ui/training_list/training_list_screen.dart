import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_calc/data/resources/assets.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/common/widgets/good_day/good_day_widget.dart';
import 'package:mind_calc/ui/training_list/training_list_screen_wm.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:mind_calc/ui/training_list/di/training_list_screen_component.dart';

import 'di/training_list_screen_wm_builder.dart';

/// Виджет списка тренировок
class TrainingListScreen extends MwwmWidget<TrainingListScreenComponent> {
  TrainingListScreen({
    Key key,
    WidgetModelBuilder wmBuilder = createTrainingListScreenWm,
  }) : super(
          key: key,
          dependenciesBuilder: (context) =>
              TrainingListScreenComponent(context),
          widgetStateBuilder: () => _TrainingListScreenState(),
          widgetModelBuilder: wmBuilder,
        );
}

/// Состояние виджета списка тренировок
class _TrainingListScreenState
    extends WidgetState<TrainingListScreenWidgetModel> {
  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return Container(
      margin: EdgeInsets.fromLTRB(16, 44, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildCompetitionBlockButton(
            Assets.dashboard,
            loc.main.leaderboard,
            () => {},
          ),
          SizedBox(height: 12),
          _buildCompetitionBlockButton(
            Assets.dashboard,
            loc.main.achievements,
            () => {},
          ),
          Expanded(child: Container(),),
          Container(child: GoodDayWidget(), alignment: Alignment.centerLeft),
          SizedBox(height: 2),
          _buildHappyTrainingText(),
          SizedBox(height: 24),
          _buildTrainingTypeBtn(
              title: loc.main.qualityTitle,
              description: loc.main.qualityDescription,
              color: ProjectColors.warmBlue,
              iconPath: Assets.quality),
          SizedBox(height: 12),
          _buildTrainingTypeBtn(
              title: loc.main.speedTitle,
              description: loc.main.speedDescription,
              color: ProjectColors.greenBlue,
              iconPath: Assets.speed),
          SizedBox(height: 12),
          _buildTrainingTypeBtn(
              title: loc.main.zenTitle,
              description: loc.main.zenDescription,
              color: ProjectColors.pinkishOrange,
              iconPath: Assets.zen),
          SizedBox(height: 24)
        ],
      ),
    );
  }

  SizedBox _buildCompetitionBlockButton(
      String assetPath, String title, VoidCallback onPressed) {
    return SizedBox(
      height: 56,
      child: RaisedButton(
        elevation: 0,
        highlightElevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                assetPath,
                color: ProjectColors.warmBlue,
                width: 24,
                height: 24,
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ProjectColors.purpleishBlue),
                ),
              ),
              SvgPicture.asset(
                Assets.arrow_right,
                color: ProjectColors.cloudyBlue,
                width: 20,
                height: 20,
              ),
            ],
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildHappyTrainingText() {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return Text(
      loc.main.happyPractice,
      style: TextStyle(
        fontSize: 14,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildTrainingTypeBtn(
      {String title, String description, Color color, String iconPath}) {
    return SizedBox(
      height: 80,
      child: FlatButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: color,
        child: Stack(
          children: <Widget>[
            SvgPicture.asset(
              Assets.bg_training_type_btn,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Center(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                            color: Colors.white),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            color: Colors.white),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SvgPicture.asset(
                    iconPath,
                    color: Colors.white,
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(
                    width: 12,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
