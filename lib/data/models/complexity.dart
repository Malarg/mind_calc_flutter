///Сложность 
class Complexity {
  
  ///айдишник же
  int id;

  ///значение сложности
  int value;

  ///Время, когда эта сложность была достигнута
  DateTime timestamp;

  Complexity(this.id, this.value, this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "value" : value,
      "timestamp" : timestamp.millisecondsSinceEpoch
    };
  }
}
