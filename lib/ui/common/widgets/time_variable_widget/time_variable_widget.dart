import 'package:flutter/widgets.dart';
import 'package:mind_calc/ui/common/widgets/time_variable_widget/time_variable_widget_wm.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:mind_calc/ui/common/widgets/time_variable_widget/di/time_variable_widget_component.dart';
import 'di/time_variable_widget_wm_builder.dart';

typedef Widget TimerWidgetCallback(Duration timeLeft);

class TimeVariableWidget extends MwwmWidget<TimeVariableWidgetComponent> {
  TimeVariableWidget(
    Duration duration,
    Duration step,
    TimerWidgetCallback playFunc, {
    VoidCallback onTimerCompleted,
    Key key,
    WidgetModelBuilder wmBuilder = createTimeVariableWidgetWm,
  }) : super(
            key: key,
            dependenciesBuilder: (context) => TimeVariableWidgetComponent(),
            widgetStateBuilder: () => _TimeVariableWidgetState(
                duration, step, playFunc, onTimerCompleted),
            widgetModelBuilder: wmBuilder);
}

class _TimeVariableWidgetState extends WidgetState<TimeVariableWidgetModel> {
  Duration duration;
  Duration step;
  TimerWidgetCallback playFunc;
  VoidCallback onTimerCompleted;
  _TimeVariableWidgetState(
      this.duration, this.step, this.playFunc, this.onTimerCompleted);

  @override
  void initState() {
    super.initState();
    wm.timerDuration = duration;
    wm.timerStep = step;
    wm.startTimer();
    wm.timerFinishedCommand.stream.listen((e) {
      onTimerCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder(
      streamedState: wm.leftTimeState,
      builder: (BuildContext context, Duration timeLeft) {
        return playFunc(timeLeft);
      },
    );
  }
}
