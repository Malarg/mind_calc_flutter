import 'dart:math';
import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surf_util/surf_util.dart';
import 'package:tuple/tuple.dart';

///https://docs.google.com/document/d/1W9kCnPQCRQKW7Vb_6BdZx_uPjw66GkrTPEC8Ii6Cg6U/edit
class CalculationProvider {
  static const double _divideCoef = 1.5;
  SharedPreferences preferences;

  CalculationProvider(this.preferences);

  /// Возвращает пару значений, где первое - пример, второе - значение на месте "?"
  Tuple2<String, int> getCalculation(int level, bool isEquationEnabled,
      List<CalculationAction> acceedOperations) {
    print("Алгоритм генерации примеров начал работу.");

    var calcItemCount = _getCalcItemsCount();
    print("Определено количество действий: $calcItemCount");

    var calcsCountValuesDivider = _getCalcsCountValuesDivider(calcItemCount);
    print(
        "Определен делитель для диапазонов допустимых значений: $calcsCountValuesDivider");

    var allowedRanges = _OperationRangeValues(
      sumRange: _getSumRangeValues(level, calcsCountValuesDivider),
      minusRange: _getSumRangeValues(level, calcsCountValuesDivider),
      multiplyRange: _getMultiplyRangeValues(level, calcsCountValuesDivider),
      divideRange: _getMultiplyRangeValues(level, calcsCountValuesDivider),
      powRange: _getPowValueRangeValues(level, calcsCountValuesDivider),
      percentRange: _getPercentRangeValues(level, calcsCountValuesDivider),
    );
    print("""Определены допустимые диапазоны для действий:
    sumRange: ${allowedRanges.sumRange}
    minusRange: ${allowedRanges.minusRange}
    multiplyRange: ${allowedRanges.multiplyRange}
    divideRange: ${allowedRanges.divideRange}
    powRange: ${allowedRanges.powRange}
    percentRange: ${allowedRanges.percentRange}
    """);

    var calcResult = allowedRanges.sumRange.random();
    print("Сгенерирован ответ для примера: $calcResult");

    var resultString = calcResult.toString();
    var currentItemsCount = 0;
    while (currentItemsCount < calcItemCount) {
      var numbersPositions = _getNumbersPosition(resultString);
      print("Определены позиции подстрок для чисел");
      numbersPositions.forEach((element) {
        print("Начало: ${element.item1}, Конец: ${element.item2}");
      });

      var allowedOperations = _getAllowedOperationsForNumbers(
          resultString, numbersPositions, allowedRanges, acceedOperations);
      print("Определены допустимые операции для каждого числа в строке:");
      allowedOperations.forEach((pos, operations) {
        var mergedOperations = operations.map((e) => e.value).join(" ");
        print(
            "Позиции подстрок чисел: (${pos.item1}, ${pos.item2}): $mergedOperations");
      });

      if (allowedOperations.isEmpty) {
        print("Допустимые операции не найдены. Возврат к началу алгоритма");
        return getCalculation(level, isEquationEnabled, acceedOperations);
      }

      var nextOperation = _getNextOperation(allowedOperations, resultString);
      print("Определена следующая операция: ${nextOperation.value}");

      _incrementOperationCount(nextOperation);
      var numberForOperation =
          _getNumberForOperation(nextOperation, allowedOperations);
      print(
          "Определена позиция для следующей операции: ${numberForOperation.item1}, ${numberForOperation.item2}");

      resultString = _splitStringWithNumberAndOperation(
          resultString, allowedRanges, numberForOperation, nextOperation);
      print("промежуточный вариант строки: $resultString");
      currentItemsCount++;
    }
    if (isEquationEnabled) {
      resultString = resultString + " = " + calcResult.toString();
      var randomNumberPosition = _getNumbersPosition(resultString).random();
      var randomNumber = int.parse(resultString.substring(
          randomNumberPosition.item1, randomNumberPosition.item2));
      resultString = resultString.substring(0, randomNumberPosition.item1) +
          "?" +
          resultString.substring(randomNumberPosition.item2);
      print(resultString);
      print("Ответ: " + randomNumber.toString());
      print("Алгоритм генерации примеров завершил работу");
      return Tuple2<String, int>(resultString, randomNumber);
    } else {
      resultString = resultString + " = ?";
      print("Ответ: " + calcResult.toString());
      print("Алгоритм генерации примеров завершил работу");
      return Tuple2<String, int>(resultString, calcResult);
    }
  }

  ///Возвращает позицию числа для разбиения
  Tuple2<int, int> _getNumberForOperation(CalculationAction nextOperation,
      Map<Tuple2<int, int>, List<CalculationAction>> allowedOperations) {
    Map<Tuple2<int, int>, List<CalculationAction>> filteredAllowedOperations =
        {};
    allowedOperations.forEach((key, value) {
      if (value.contains(nextOperation)) {
        filteredAllowedOperations[key] = value;
      }
    });
    return filteredAllowedOperations.keys.toList().random();
  }

  int _getCalcItemsCount() {
    var rand = Random();
    var randValue = rand.nextInt(100);
    int actionsCount = 1;
    if (randValue > 40) actionsCount++;
    if (randValue > 70) actionsCount++;
    if (randValue > 90) actionsCount++;
    return actionsCount;
  }

  /// Возвращает допустимый диапазон значений для операций сложения и вычитания
  Tuple2<int, int> _getSumRangeValues(int level, double divider) {
    var minValue = max(level ~/ divider, 1);
    var maxValue = max(level * 2 ~/ divider, 10);
    return Tuple2<int, int>(minValue, maxValue);
  }

  /// Возвращает допустимый диапазон значений для операций умножения и деления
  Tuple2<int, int> _getMultiplyRangeValues(int level, double divider) {
    var minValue = max(sqrt(level).toInt() * 4 ~/ divider, 2);
    var maxValue = max(sqrt(level).toInt() * 6 ~/ divider, 10);
    return Tuple2<int, int>(minValue, maxValue);
  }

  /// Возвращает допустимый диапазон значений для показателя возведения в степень
  Tuple2<int, int> _getPowValueRangeValues(int level, double divider) {
    return Tuple2<int, int>(2, 2 + level ~/ 50);
  }

  /// Возвращает допустимый диапазон значений для операции взятия процента
  Tuple2<int, int> _getPercentRangeValues(int level, double divider) {
    var minValue = 1;
    var maxValue = level * 5;
    return Tuple2<int, int>(minValue, maxValue);
  }

  ///Возвращает позиции начала (включительно) и конца (не включительно) числа в строке
  List<Tuple2<int, int>> _getNumbersPosition(String input) {
    var numbers = "0123456789";

    bool isNumberBegin(int index) =>
        numbers.contains(input[index]) &&
        (index == 0 || !numbers.contains(input[index - 1]));

    bool isNumberEnd(int index) =>
        numbers.contains(input[index]) &&
        (index == input.length - 1 || !numbers.contains(input[index + 1]));

    List<int> begins = [];
    List<int> ends = [];
    for (var i = 0; i < input.length; i++) {
      if (isNumberBegin(i)) {
        begins.add(i);
      }
      if (isNumberEnd(i)) {
        ends.add(i);
      }
    }

    List<Tuple2<int, int>> result = [];
    for (var i = 0; i < begins.length; i++) {
      result.add(Tuple2<int, int>(begins[i], ends[i] + 1));
    }
    return result;
  }

  ///Определяет допустимые операции для каждого числа. Числа передаются через позиции подстроки входящей строки
  Map<Tuple2<int, int>, List<CalculationAction>>
      _getAllowedOperationsForNumbers(
    String inputString,
    List<Tuple2<int, int>> numbersPositions,
    _OperationRangeValues ranges,
    List<CalculationAction> acceedOperations,
  ) {
    Map<Tuple2<int, int>, List<CalculationAction>> result = {};
    numbersPositions.forEach((numberString) {
      var number = int.parse(
          inputString.substring(numberString.item1, numberString.item2));
      var allowedOperations =
          _buildAllowedOperations(number, ranges).intersect(acceedOperations);
      if (allowedOperations.isNotEmpty) {
        result[numberString] = allowedOperations;
      }
    });
    return result;
  }

  List<CalculationAction> _buildAllowedOperations(
      int number, _OperationRangeValues ranges) {
    List<CalculationAction> allowedOperations = <CalculationAction>[];
    if (_canSplitWithPlus(number, ranges.sumRange)) {
      allowedOperations.add(CalculationAction.PLUS);
    }
    if (_canSplitWithMinus(number, ranges.minusRange)) {
      allowedOperations.add(CalculationAction.MINUS);
    }
    if (_canSplitWithMultiply(number, ranges.multiplyRange)) {
      allowedOperations.add(CalculationAction.MULTIPLY);
    }
    if (_canSplitWithDivide(number, ranges.divideRange)) {
      allowedOperations.add(CalculationAction.DIVIDE);
    }
    if (_canSplitWithPow(number, ranges.powRange)) {
      allowedOperations.add(CalculationAction.POW);
    }
    if (_canSplitWithPercent(number, ranges.percentRange)) {
      allowedOperations.add(CalculationAction.PERCENT);
    }
    return allowedOperations;
  }

  ///Определяет следующее действие для разбиения
  CalculationAction _getNextOperation(
      Map<Tuple2<int, int>, List<CalculationAction>> allowedOperations,
      String resultString) {
    var totalOperationsCount = _getTotalOperationCount();
    CalculationAction result;
    for (var fOperation in totalOperationsCount) {
      for (var aOperation in allowedOperations.values) {
        if (aOperation.any((elem) => fOperation.item1.value == elem.value) &&
            result == null) {
          result = fOperation.item1;
        }
      }
    }
    return result;
  }

  ///Возвращает количество уже сгенерированных действий для каждого из них в порядке возрастания
  List<Tuple2<CalculationAction, int>> _getTotalOperationCount() {
    List<Tuple2<CalculationAction, int>> result = [];
    result.add(Tuple2<CalculationAction, int>(CalculationAction.PLUS,
        preferences.getInt(PrefsValues.calcPlusCount)));
    result.add(Tuple2<CalculationAction, int>(CalculationAction.MINUS,
        preferences.getInt(PrefsValues.calcMinusCount)));
    result.add(Tuple2<CalculationAction, int>(CalculationAction.MULTIPLY,
        preferences.getInt(PrefsValues.calcMultiplyCount)));
    result.add(Tuple2<CalculationAction, int>(CalculationAction.DIVIDE,
        preferences.getInt(PrefsValues.calcDivideCount)));
    result.add(Tuple2<CalculationAction, int>(
        CalculationAction.POW, preferences.getInt(PrefsValues.calcPowCount)));
    result.add(Tuple2<CalculationAction, int>(CalculationAction.PERCENT,
        preferences.getInt(PrefsValues.calcPercentCount)));
    result.sort((a, b) {
      if (a.item2 < b.item2) {
        return -1;
      }
      if (a.item2 > b.item2) {
        return 1;
      }
      return 0;
    });
    return result;
  }

  ///Разделяет число с указанной позицией на указанную операцию
  String _splitStringWithNumberAndOperation(
      String resultString,
      _OperationRangeValues ranges,
      Tuple2<int, int> numberForOperation,
      CalculationAction nextOperation) {
    String _splittedNumber;
    var number = int.parse(resultString.substring(
        numberForOperation.item1, numberForOperation.item2));
    switch (nextOperation) {
      case CalculationAction.PLUS:
        {
          _splittedNumber = _splitWithPlusOrMinus(number, ranges.sumRange);
        }
        break;
      case CalculationAction.MINUS:
        {
          _splittedNumber = _splitWithPlusOrMinus(number, ranges.minusRange);
        }
        break;
      case CalculationAction.MULTIPLY:
        {
          _splittedNumber = _splitWithMultiply(number, ranges.multiplyRange);
        }
        break;
      case CalculationAction.DIVIDE:
        {
          _splittedNumber = _splitWithDivide(number, ranges.divideRange);
        }
        break;
      case CalculationAction.POW:
        {
          _splittedNumber = _splitWithPow(number, ranges.powRange);
        }
        break;
      case CalculationAction.PERCENT:
        {
          _splittedNumber = _splitWithPercent(number, ranges.percentRange);
        }
        break;
    }
    var leftOperation =
        _getNearestAction(resultString, numberForOperation.item1, -1);
    print("определена операция слева от ${numberForOperation.item1}: " +
        (leftOperation == null ? "null" : leftOperation.value));

    var rightOperation =
        _getNearestAction(resultString, numberForOperation.item2 - 1, 1);
    print("определена операция справа от ${numberForOperation.item2 - 1}: " +
        (rightOperation == null ? "null" : rightOperation.value));

    var rules = _buildWrapBracketRules();
    var shoudWrapFromLeft = rules
        .firstWhere((l) => l.action == nextOperation)
        .leftActions
        .contains(leftOperation);
    var shoudWrapFromRight = rules
        .firstWhere((l) => l.action == nextOperation)
        .rightActions
        .contains(rightOperation);
    if (shoudWrapFromLeft || shoudWrapFromRight) {
      _splittedNumber = "(" + _splittedNumber + ")";
    }
    return resultString.substring(0, numberForOperation.item1) +
        _splittedNumber +
        resultString.substring(numberForOperation.item2, resultString.length);
  }

  ///Определяет, возможно ли разбить число на сумму с учетом диапазона
  bool _canSplitWithPlus(int value, Tuple2<int, int> range) =>
      value > range.item1 && value < range.item2 * 2;

  ///Определяет, возможно ли разбить число на разность с учетом диапазона
  bool _canSplitWithMinus(int value, Tuple2<int, int> range) =>
      value > 0 && value < range.item2 - range.item1;

  ///Определяет, возможно ли разбить число на произведение с учетом диапазона
  bool _canSplitWithMultiply(int value, Tuple2<int, int> range) {
    bool result = false;
    var dividers = _getAllDividers(value);
    if (dividers.isEmpty) {
      return result;
    }
    dividers.forEach((divider) {
      var anotherDivider = value / divider;
      if (range.contains(divider + anotherDivider)) {
        result = true;
      }
    });
    return result;
  }

  ///Определяет, возможно ли разбить число на частное с учетом диапазона
  bool _canSplitWithDivide(int value, Tuple2<int, int> range) =>
      range.contains(value * 2 + 2) && value > 0;

  ///Определяет, возможно ли разбить число на возведение в степень с учетом диапазона
  bool _canSplitWithPow(int value, Tuple2<int, int> range) {
    if (value == 0 || value == 1) {
      return false;
    }
    bool result = false;
    range.forEach((element) {
      if (pow(value, 1 / element) % 1 == 0) {
        result = true;
      }
    });
    return result;
  }

  ///Определяет, возможно ли разбить число на взятие процента в пределах допустимого диапазона
  bool _canSplitWithPercent(int value, Tuple2<int, int> range) {
    var result = false;
    for (var i = 0.05; i <= 2; i += 0.05) {
      if (range.contains(value / i) && (value / i) % 10 == 0) {
        result = true;
      }
    }
    return result;
  }

  String _splitWithPlusOrMinus(int value, Tuple2<int, int> range) {
    var item1 = range.random();
    var item2 = value - item1;
    return item1.toString() +
        (item2 > 0 ? " + " : " - ") +
        item2.abs().toString();
  }

  String _splitWithMultiply(int value, Tuple2<int, int> range) {
    var item1 = _getAllDividers(value).random();
    var item2 = value ~/ item1;
    return item1.toString() + " ⨯ " + item2.toString();
  }

  String _splitWithDivide(int value, Tuple2<int, int> range) {
    var divider = range.random();
    return (value * divider).toString() + " ÷ " + divider.toString();
  }

  String _splitWithPow(int value, Tuple2<int, int> range) {
    for (var i = range.item1; i <= range.item2; i++) {
      if (pow(value, 1 / i) % 1 == 0) {
        return pow(value, 1 / i).toInt().toString() + " ^ " + i.toString();
      }
    }
    throw Exception(
        "Произошла ошибка при разбиении числа на возведение в степень");
  }

  String _splitWithPercent(int value, Tuple2<int, int> range) {
    var allowedPercentValues = <double>[];
    for (var i = 0.05; i <= 2; i += 0.05) {
      if (range.contains(value / i) && (value / i) % 10 == 0) {
        allowedPercentValues.add(double.parse(i.toStringAsFixed(2)));
      }
    }
    var selectedPercent = allowedPercentValues.random();
    return (selectedPercent * 100).round().toString() +
        " % " +
        (value / selectedPercent).round().toString();
  }

  /// получает все делители для числа
  List<int> _getAllDividers(int value) {
    List<int> result = [];
    for (int i = 2; i < value ~/ 2; i++) {
      if (value % i == 0) {
        result.add(i);
      }
    }
    return result;
  }

  /// Возвращает делитель для диапазонов операций. Чем больше количество действий, тем больше делитель, тем меньше значения
  double _getCalcsCountValuesDivider(int calcsCount) {
    return pow(_divideCoef, calcsCount - 1);
  }

  ///Увеличивает в преференсах счетчик операций для указанной операции
  void _incrementOperationCount(CalculationAction operation) {
    var operationPrefString;
    switch (operation) {
      case (CalculationAction.PLUS):
        {
          operationPrefString = PrefsValues.calcPlusCount;
        }
        break;
      case (CalculationAction.MINUS):
        {
          operationPrefString = PrefsValues.calcMinusCount;
        }
        break;
      case (CalculationAction.MULTIPLY):
        {
          operationPrefString = PrefsValues.calcMultiplyCount;
        }
        break;
      case (CalculationAction.DIVIDE):
        {
          operationPrefString = PrefsValues.calcDivideCount;
        }
        break;
      case (CalculationAction.POW):
        {
          operationPrefString = PrefsValues.calcPowCount;
        }
        break;
      case (CalculationAction.PERCENT):
        {
          operationPrefString = PrefsValues.calcPercentCount;
        }
        break;
    }
    preferences.setInt(
        operationPrefString, preferences.getInt(operationPrefString) + 1);
  }

  ///Возвращает ближайшее действие для входящей подстроки с указаной позициив указанном направлении.
  ///1 - движение вправо. -1 - движение влево
  CalculationAction _getNearestAction(
      String str, int startPosition, int direction) {
    var currentPosition = startPosition;
    while (true) {
      if ((currentPosition == 0 && direction == -1) ||
          (currentPosition == str.length - 1 && direction == 1)) {
        return null;
      }
      if (str[currentPosition] == "(" || str[currentPosition] == ")") {
        return null;
      }
      if (str[currentPosition] == "+") {
        return CalculationAction.PLUS;
      }
      if (str[currentPosition] == "-") {
        return CalculationAction.MINUS;
      }
      if (str[currentPosition] == "⨯") {
        return CalculationAction.MULTIPLY;
      }
      if (str[currentPosition] == "÷") {
        return CalculationAction.DIVIDE;
      }
      if (str[currentPosition] == "%") {
        return CalculationAction.PERCENT;
      }
      if (str[currentPosition] == "^") {
        return CalculationAction.POW;
      }
      currentPosition += direction;
    }
  }

  ///Возвращает данные для правила оборачивания указанного действия в скобки
  ///Само правило: если для указанного действия слева стоит действие, указанное в списке,
  ///или справа от указанного действия стоит действие, указанное в списке,
  ///действие нужно оборачивать в скобки
  List<_WrapActionWithBracketRule> _buildWrapBracketRules() {
    return [
      _WrapActionWithBracketRule(
        action: CalculationAction.PLUS,
        leftActions: [
          CalculationAction.MINUS,
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
        rightActions: [
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
      ),
      _WrapActionWithBracketRule(
        action: CalculationAction.MINUS,
        leftActions: [
          CalculationAction.MINUS,
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
        rightActions: [
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
      ),
      _WrapActionWithBracketRule(
        action: CalculationAction.MULTIPLY,
        leftActions: [
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
        rightActions: [
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
      ),
      _WrapActionWithBracketRule(
        action: CalculationAction.DIVIDE,
        leftActions: [
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
        rightActions: [
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
      ),
      _WrapActionWithBracketRule(
        action: CalculationAction.PERCENT,
        leftActions: [
          CalculationAction.PLUS,
          CalculationAction.MINUS,
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
        rightActions: [
          CalculationAction.PLUS,
          CalculationAction.MINUS,
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
      ),
      _WrapActionWithBracketRule(
        action: CalculationAction.POW,
        leftActions: [
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
        rightActions: [
          CalculationAction.MULTIPLY,
          CalculationAction.DIVIDE,
          CalculationAction.PERCENT,
          CalculationAction.POW,
        ],
      ),
    ];
  }
}

extension TupleOperationsExtentions on Tuple2<int, int> {
  Tuple2<int, int> divide(num value) {
    return Tuple2(item1 ~/ value, item2 ~/ value);
  }

  int random() {
    var rand = Random();
    return rand.nextInt(item2 - item1) + item1;
  }

  bool contains(num value) {
    return value >= item1 && value <= item2;
  }

  void forEach(void f(int element)) {
    for (int i = item1; i <= item2; i++) {
      f(i);
    }
  }
}

extension ListOperationExtension<T> on List<T> {
  T random() {
    var rand = Random();
    return this[rand.nextInt(length)];
  }

  List<T> intersect(List<T> anotherList) {
    var result = <T>[];
    anotherList.forEach((element) {
      if (this.contains(element)) {
        result.add(element);
      }
    });
    return result;
  }
}

class CalculationAction extends Enum<String> {
  const CalculationAction(String value) : super(value);

  static const PLUS = CalculationAction("PLUS");
  static const MINUS = CalculationAction("MINUS");
  static const MULTIPLY = CalculationAction("MULTIPLY");
  static const DIVIDE = CalculationAction("DIVIDE");
  static const PERCENT = CalculationAction("PERCENT");
  static const POW = CalculationAction("POW");
}

class _OperationRangeValues {
  Tuple2<int, int> sumRange;
  Tuple2<int, int> minusRange;
  Tuple2<int, int> multiplyRange;
  Tuple2<int, int> divideRange;
  Tuple2<int, int> powRange;
  Tuple2<int, int> percentRange;

  _OperationRangeValues(
      {this.sumRange,
      this.minusRange,
      this.multiplyRange,
      this.divideRange,
      this.powRange,
      this.percentRange});
}

class _WrapActionWithBracketRule {
  CalculationAction action;
  List<CalculationAction> leftActions;
  List<CalculationAction> rightActions;
  _WrapActionWithBracketRule(
      {this.action, this.leftActions, this.rightActions});
}
