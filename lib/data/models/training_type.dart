import 'package:mind_calc/ui/training/training_screen_wm.dart';

///Тип тренировки
class TrainingType {

  ///айдишник
  int id;

  ///тип тренировки
  TrainingTypeEnum type;

  TrainingType(this.id, this.type);

  Map<String, dynamic> toMap() {
    return {"id": id, "value": type.value};
  }
}
