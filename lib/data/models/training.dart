import 'package:mind_calc/data/models/training_type.dart';

///Тренировка
class Training {
  ///айдишник тренировки
  int id;

  ///Тип тренировки
  TrainingType type;

  ///Была ли тренировка закончена
  bool isFinished;

  ///Время начала тренировки
  DateTime startTime;

  ///Продолжительность тренировки
  Duration duration;

  Training(this.id, this.type, this.isFinished, this.startTime, this.duration);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "isFinished": isFinished ? 1 : 0,
      "startTime": startTime.millisecondsSinceEpoch,
      "duration": duration.inMilliseconds,
      "typeId": type.id
    };
  }
}
