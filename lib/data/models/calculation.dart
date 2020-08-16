import 'package:mind_calc/data/models/training.dart';

///Пример
class Calculation {
  ///айдишник примера
  int id;

  ///Тренировка, в рамках которой вычислялся пример
  Training training;

  ///Время, когда был дан ответ на пример
  DateTime timestamp;

  ///Строковое представление вычисления. Знак вопроса - предполагаемый ответ
  String value;

  ///Ответ, который дал пользователь
  String result;

  ///Верный ответ на пример
  String answer;

  Calculation({
    this.id,
    this.training,
    this.timestamp,
    this.value,
    this.result,
    this.answer,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "trainingId": training.id,
      "value": value,
      "result": result,
      "answer": answer,
      "timestamp": timestamp.millisecondsSinceEpoch
    };
  }
}
