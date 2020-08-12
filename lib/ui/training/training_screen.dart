import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mind_calc/data/resources/assets.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/ui/common/widgets/time_variable_widget/time_variable_widget.dart';
import 'package:mind_calc/ui/training/di/training_screen_component.dart';
import 'package:mind_calc/ui/training/training_screen_wm.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:tuple/tuple.dart';
import 'di/training_screen_wm_builder.dart';

class TrainingScreen extends MwwmWidget<TrainingScreenComponent> {
  TrainingScreen(
    TrainingType type, {
    Key key,
    WidgetModelBuilder wmBuilder = createTrainingScreenWm,
  }) : super(
          key: key,
          dependenciesBuilder: (context) =>
              TrainingScreenComponent(context, type),
          widgetStateBuilder: () => _TrainingScreenState(),
          widgetModelBuilder: wmBuilder,
        );
}

class _TrainingScreenState extends WidgetState<TrainingScreenWidgetModel>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double widgetWidth;
  bool isCrossFadeShowingFirst = true;

  @override
  void initState() {
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    Tween tween = new Tween<double>(begin: 1, end: 0);
    animation = tween.animate(controller);
    animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.iceBlue,
      body: StreamedStateBuilder(
        streamedState: wm.isScreenHasBeenStartedState,
        builder: (context, isScreenHasBeenStarted) {
          if (isScreenHasBeenStarted) {
            return buildNormalState();
          } else {
            return TimeVariableWidget(
              Duration(seconds: 3),
              Duration(milliseconds: 16),
              (timeLeft) {
                return Center(
                  child: Transform.scale(
                    scale:
                        5 + (timeLeft.inMilliseconds % 1000).toDouble() / 300,
                    child: Text(
                      (timeLeft.inSeconds + 1).toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Montserrat",
                          color: ProjectColors.warmBlue),
                    ),
                  ),
                );
              },
              onTimerCompleted: () {
                wm.startTimerHasBeenExpiredAction.accept();
              },
            );
          }
        },
      ),
    );
  }

  Column buildNormalState() {
    return Column(
      children: [
        StreamedStateBuilder(
          streamedState: wm.sessionTypeInfoState,
          builder: (context, String sessionInfo) {
            return sessionInfo == null
                ? Container()
                : _GameTypeText(sessionInfo);
          },
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: StreamedStateBuilder(
                streamedState: wm.calculationState,
                builder: (ctx, Tuple2<String, int> calc) {
                  return StreamedStateBuilder(
                    streamedState: wm.currentTextState,
                    builder: (context, currText) {
                      return _CalculationText(
                        calc.item1,
                        currText ?? "",
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            StreamedStateBuilder(
              streamedState: wm.isLastCalculationCorrectState,
              builder: (context, bool isCorrect) {
                var icon = Icon(
                  isCorrect ?? true ? Icons.check : Icons.close,
                  size: 56,
                  color: isCorrect ?? true
                      ? ProjectColors.greenBlue
                      : ProjectColors.salmonPink,
                );
                controller.forward();
                return isCorrect == null
                    ? Container()
                    : Opacity(opacity: animation.value, child: icon);
              },
            ),
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
                color: ProjectColors.salmonPink,
                onPressed: () {},
                child: SvgPicture.asset(
                  Assets.pause,
                  color: Colors.white,
                  height: 24,
                ),
              ),
            ),
            SizedBox(
              width: 16,
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("1"),
                  onPressed: () {
                    wm.addTextAction.accept("1");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("2"),
                  onPressed: () {
                    wm.addTextAction.accept("2");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("3"),
                  onPressed: () {
                    wm.addTextAction.accept("3");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("4"),
                  onPressed: () {
                    wm.addTextAction.accept("4");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("5"),
                  onPressed: () {
                    wm.addTextAction.accept("5");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("6"),
                  onPressed: () {
                    wm.addTextAction.accept("6");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("7"),
                  onPressed: () {
                    wm.addTextAction.accept("7");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("8"),
                  onPressed: () {
                    wm.addTextAction.accept("8");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("9"),
                  onPressed: () {
                    wm.addTextAction.accept("9");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: Icon(
                    Icons.close,
                    color: ProjectColors.salmonPink,
                  ),
                  onPressed: () {
                    wm.clearTextAction.accept();
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: _KeyboardText("0"),
                  onPressed: () {
                    wm.addTextAction.accept("0");
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2.15,
                child: _TrainingKeyboardButton(
                  child: Icon(
                    Icons.check,
                    color: ProjectColors.greenBlue,
                  ),
                  onPressed: () {
                    controller.reset();
                    wm.acceptTextAction.accept();
                  },
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class _TrainingKeyboardButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  _TrainingKeyboardButton({this.child, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: child,
        onPressed: () {
          onPressed();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: Colors.white);
  }
}

class _KeyboardText extends StatelessWidget {
  final String text;
  _KeyboardText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: "Montserrat",
          color: ProjectColors.duscTwo),
    );
  }
}

class _GameTypeText extends StatelessWidget {
  final String text;
  _GameTypeText(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 44, 16, 0),
      child: SizedBox(
        height: 40,
        width: 96,
        child: Container(
          decoration: BoxDecoration(
            color: ProjectColors.pinkishOrange,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Montserrat",
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalculationText extends StatelessWidget {
  final String calculationText;
  final String resultValue;
  _CalculationText(this.calculationText, this.resultValue);

  @override
  Widget build(BuildContext context) {
    TextStyle calcTextStyle = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      fontFamily: "Montserrat",
      color: ProjectColors.duscTwo,
    );
    var calcTexts = calculationText.split("?");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          calcTexts[0],
          style: calcTextStyle,
        ),
        _InputResult(resultValue),
        Text(
          calcTexts[1],
          style: calcTextStyle,
        ),
      ],
    );
  }
}

class _InputResult extends StatelessWidget {
  final String text;
  _InputResult(this.text);
  @override
  Widget build(BuildContext context) {
    var textNullOrEmpty = text == null || text.isEmpty;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      child: Text(
        textNullOrEmpty ? "?" : text,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          fontFamily: "Montserrat",
          color: textNullOrEmpty
              ? ProjectColors.cloudyBlue
              : ProjectColors.duscTwo,
        ),
      ),
    );
  }
}
