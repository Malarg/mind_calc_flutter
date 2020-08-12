import 'dart:async';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class TimeVariableWidgetModel extends WidgetModel {
  Duration timerStep;
  Duration timerDuration;
  DateTime endTime;
  Timer timer;

  final leftTimeState = StreamedState<Duration>();
  final timerFinishedCommand = StreamedState<void>();

  TimeVariableWidgetModel(WidgetModelDependencies baseDependencies)
      : super(baseDependencies);

  void startTimer() {
    var currentTime = DateTime.now();
    endTime = currentTime.add(timerDuration);
    leftTimeState.accept(timerDuration);
    timer = Timer.periodic(timerStep, (t) {
      currentTime = DateTime.now();
      if (endTime.isBefore(currentTime)) {
        leftTimeState.accept(Duration());
        timerFinishedCommand.accept();
        t.cancel();
      }
      var leftTime = endTime.difference(currentTime);
      leftTimeState.accept(leftTime);
    });
  }
}
