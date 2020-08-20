import 'dart:async';

import 'package:mind_calc/ui/training/training_screen_wm.dart';

typedef void OnSessionInfoChanged(String info);

const int QUALITY_TYPE_CALC_COUNT = 20;

class TrainingSessionHandler {
  final TrainingTypeEnum _trainingType;
  Timer _speedTypeTimer;
  int _timerTicksLeft = 60;
  int _completedCalculationsCount = 0;
  final OnSessionInfoChanged onSessionInfoChanged;

  TrainingSessionHandler(this._trainingType, this.onSessionInfoChanged) {
    if (_trainingType == TrainingTypeEnum.QUALITY) {
      onSessionInfoChanged(
          "$_completedCalculationsCount / $QUALITY_TYPE_CALC_COUNT");
    }
    resumeTimer();
  }

  bool shouldFinishOnCalculationCompleted() {
    if (_trainingType == TrainingTypeEnum.QUALITY) {
      _completedCalculationsCount++;
      onSessionInfoChanged(
            "$_completedCalculationsCount / $QUALITY_TYPE_CALC_COUNT");
      if (_completedCalculationsCount >= QUALITY_TYPE_CALC_COUNT) {
        return true;
      } 
    }
    if (_trainingType == TrainingTypeEnum.SPEED) {
      if (_timerTicksLeft == 0) {
        return true;
      }
    }
    return false;
  }

  void resumeTimer() {
    if (_trainingType == TrainingTypeEnum.SPEED) {
      if (_timerTicksLeft > 0) {
        _timerTicksLeft--;
      }
      onSessionInfoChanged(_timerTicksLeft.toString());
      _speedTypeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_timerTicksLeft > 0) {
          _timerTicksLeft--;
        }
        onSessionInfoChanged(_timerTicksLeft.toString());
        if (_timerTicksLeft == 0) {
          timer.cancel();
        }
      });
    }
  }

  void pauseTimer() {
    if (_trainingType == TrainingTypeEnum.SPEED) {
      _speedTypeTimer.cancel();
    }
  }
}
