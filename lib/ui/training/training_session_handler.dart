import 'dart:async';

import 'package:mind_calc/ui/training/training_screen_wm.dart';

typedef void OnSessionInfoChanged(String info);

const int QUALITY_TYPE_CALC_COUNT = 20;

class TrainingSessionHandler {
  final TrainingType _trainingType;
  Timer speedTypeTimer;
  int timerTicksLeft = 60;
  int completedCalculationsCount = 0;
  final OnSessionInfoChanged onSessionInfoChanged;

  TrainingSessionHandler(this._trainingType, this.onSessionInfoChanged) {
    if (_trainingType == TrainingType.QUALITY) {
      onSessionInfoChanged(
          "$completedCalculationsCount / $QUALITY_TYPE_CALC_COUNT");
    }
    if (_trainingType == TrainingType.SPEED) {
      onSessionInfoChanged(timerTicksLeft.toString());
      speedTypeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timerTicksLeft > 0) {
          timerTicksLeft--;
        }
        onSessionInfoChanged(timerTicksLeft.toString());
        if (timerTicksLeft == 0) {
          timer.cancel();
        }
      });
    }
  }

  bool shouldFinishOnCalculationCompleted() {
    if (_trainingType == TrainingType.QUALITY) {
      if (completedCalculationsCount >= QUALITY_TYPE_CALC_COUNT) {
        return true;
      } else {
        completedCalculationsCount++;
      onSessionInfoChanged(
          "$completedCalculationsCount / $QUALITY_TYPE_CALC_COUNT");
      }
    }
    if (_trainingType == TrainingType.SPEED) {
      if (timerTicksLeft == 0) {
        return true;
      }
    }
    return false;
  }
}
