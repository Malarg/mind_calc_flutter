import 'dart:math';
import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:surf_util/surf_util.dart';
import 'package:tuple/tuple.dart';

///Баги:
///Дублируются операции для допустимых чисел
///Если нет операций для числа - ошибка

///https://docs.google.com/document/d/1W9kCnPQCRQKW7Vb_6BdZx_uPjw66GkrTPEC8Ii6Cg6U/edit
class CalculationProvider {
  static const double _divideCoef = 1.5;

  /// Возвращает пару значений, где первое - пример, второе - значение на месте "?"
  Tuple2<String, int> getCalculation(int level) {
    var calcItemCount = _getCalcItemsCount();
    var calcsCountValuesDivider = _getCalcsCountValuesDivider(calcItemCount);
    var allowedRanges = _OperationRangeValues(
      sumRange: _getSumRangeValues(level, calcsCountValuesDivider),
      minusRange: _getSumRangeValues(level, calcsCountValuesDivider),
      multiplyRange: _getMultiplyRangeValues(level, calcsCountValuesDivider),
      divideRange: _getMultiplyRangeValues(level, calcsCountValuesDivider),
      powRange: _getPowValueRangeValues(level, calcsCountValuesDivider),
      percentRange: _getSumRangeValues(level, calcsCountValuesDivider),
    );
    var calcResult = allowedRanges.sumRange.random();
    var resultString = calcResult.toString();
    var currentItemsCount = 0;
    while (currentItemsCount <= calcItemCount) {
      var numbersPositions = _getNumbersPosition(resultString);
      var allowedOperations = _getAllowedOperationsForNumbers(
          resultString, numbersPositions, allowedRanges);
      if (allowedOperations.isEmpty) {
        return getCalculation(level);
      }
      var nextOperation = _getNextOperation(allowedOperations, resultString);
      _incrementOperationCount(nextOperation);
      var numberForOperation =
          _getNumberForOperation(nextOperation, allowedOperations);
      resultString = _splitStringWithNumberAndOperation(
          resultString, allowedRanges, numberForOperation, nextOperation);
      currentItemsCount++;
    }
    print(resultString + " = " + calcResult.toString());
    return Tuple2<String, int>(resultString, calcResult);
  }

  ///Возвращает позицию числа для разбиения
  Tuple2<int, int> _getNumberForOperation(_CalculationAction nextOperation,
      Map<Tuple2<int, int>, List<_CalculationAction>> allowedOperations) {
    Map<Tuple2<int, int>, List<_CalculationAction>> filteredAllowedOperations =
        {};
    allowedOperations.forEach((key, value) {
      if (value.contains(nextOperation)) {
        filteredAllowedOperations[key] = value;
      }
    });
    return filteredAllowedOperations.keys.toList().random();
  }

  /// Возвращает количество действий
  /// формула распределения: -sqrt(sqrt(x)) * 2.84 + 10
  int _getCalcItemsCount() {
    var rand = Random();
    var randValue = rand.nextInt(100);
    var raspRand = -1 * sqrt(sqrt(randValue)) * 2.84 + 10;
    return raspRand.round();
  }

  /// Возвращает допустимый диапазон значений для операций сложения и вычитания
  Tuple2<int, int> _getSumRangeValues(int level, double divider) {
    return Tuple2<int, int>(level, (level * 2)).divide(divider);
  }

  /// Возвращает допустимый диапазон значений для операций умножения и деления
  Tuple2<int, int> _getMultiplyRangeValues(int level, double divider) {
    var minValue = sqrt(level).toInt() * 4;
    var maxValue = sqrt(level).toInt() * 6;
    return Tuple2<int, int>(minValue, maxValue).divide(divider);
  }

  /// Возвращает допустимый диапазон значений для показателя возведения в степень
  Tuple2<int, int> _getPowValueRangeValues(int level, double divider) {
    return Tuple2<int, int>(level ~/ 100, level ~/ 50).divide(divider);
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
  Map<Tuple2<int, int>, List<_CalculationAction>>
      _getAllowedOperationsForNumbers(
          String inputString,
          List<Tuple2<int, int>> numbersPositions,
          _OperationRangeValues ranges) {
    Map<Tuple2<int, int>, List<_CalculationAction>> result = {};
    numbersPositions.forEach((numberString) {
      var number = int.parse(
          inputString.substring(numberString.item1, numberString.item2));
      var allowedOperations = _buildAllowedOperations(number, ranges);
      if (allowedOperations.isNotEmpty) {
        result[numberString] = allowedOperations;
      }
    });
    return result;
  }

  List<_CalculationAction> _buildAllowedOperations(
      int number, _OperationRangeValues ranges) {
    List<_CalculationAction> allowedOperations = <_CalculationAction>[];
    if (_canSplitWithPlus(number, ranges.sumRange)) {
      allowedOperations.add(_CalculationAction.PLUS);
    }
    if (_canSplitWithMinus(number, ranges.minusRange)) {
      allowedOperations.add(_CalculationAction.MINUS);
    }
    if (_canSplitWithMultiply(number, ranges.multiplyRange)) {
      allowedOperations.add(_CalculationAction.MULTIPLY);
      allowedOperations.add(_CalculationAction.MULTIPLY);
    }
    if (_canSplitWithDivide(number, ranges.divideRange)) {
      allowedOperations.add(_CalculationAction.DIVIDE);
    }
    if (_canSplitWithPow(number, ranges.powRange)) {
      allowedOperations.add(_CalculationAction.POW);
    }
    if (_canSplitWithPercent(number, ranges.percentRange)) {
      allowedOperations.add(_CalculationAction.PERCENT);
    }
    return allowedOperations;
  }

  ///Определяет следующее действие для разбиения
  _CalculationAction _getNextOperation(
      Map<Tuple2<int, int>, List<_CalculationAction>> allowedOperations,
      String resultString) {
    var totalOperationsCount = _getTotalOperationCount();
    totalOperationsCount.forEach((operation) {
      allowedOperations.values.forEach((element) {
        if (element.any((element) => operation.item1 == element)) {
          return operation.item1;
        }
      });
    });
    return _CalculationAction.PLUS;
  }

  List<Tuple2<_CalculationAction, int>> _getTotalOperationCount() {
    List<Tuple2<_CalculationAction, int>> result = [];
    SharedPreferences.getInstance().then((prefs) {
      result.add(Tuple2<_CalculationAction, int>(
          _CalculationAction.PLUS, prefs.getInt(PrefsValues.calcPlusCount)));
      result.add(Tuple2<_CalculationAction, int>(
          _CalculationAction.MINUS, prefs.getInt(PrefsValues.calcMinusCount)));
      result.add(Tuple2<_CalculationAction, int>(_CalculationAction.MULTIPLY,
          prefs.getInt(PrefsValues.calcMultiplyCount)));
      result.add(Tuple2<_CalculationAction, int>(_CalculationAction.DIVIDE,
          prefs.getInt(PrefsValues.calcDivideCount)));
      result.add(Tuple2<_CalculationAction, int>(
          _CalculationAction.POW, prefs.getInt(PrefsValues.calcPowCount)));
      result.add(Tuple2<_CalculationAction, int>(_CalculationAction.PERCENT,
          prefs.getInt(PrefsValues.calcPercentCount)));
    });
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
      _CalculationAction nextOperation) {
    String _splittedNumber;
    var number = int.parse(resultString.substring(
        numberForOperation.item1, numberForOperation.item2));
    switch (nextOperation) {
      case _CalculationAction.PLUS:
        {
          _splittedNumber = _splitWithPlusOrMinus(number, ranges.sumRange);
        }
        break;
      case _CalculationAction.MINUS:
        {
          _splittedNumber = _splitWithPlusOrMinus(number, ranges.minusRange);
        }
        break;
      case _CalculationAction.MULTIPLY:
        {
          _splittedNumber = _splitWithMultiply(number, ranges.multiplyRange);
        }
        break;
      case _CalculationAction.DIVIDE:
        {
          _splittedNumber = _splitWithDivide(number, ranges.divideRange);
        }
        break;
      case _CalculationAction.POW:
        {
          _splittedNumber = _splitWithPow(number, ranges.powRange);
        }
        break;
      case _CalculationAction.PERCENT:
        {
          _splittedNumber = _splitWithMultiply(number, ranges.percentRange);
        }
        break;
    }
    return resultString.substring(0, numberForOperation.item1) +
        " (" +
        _splittedNumber +
        ") " +
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
      range.contains(value * 2 + 2);

  ///Определяет, возможно ли разбить число на возведение в степень с учетом диапазона
  bool _canSplitWithPow(int value, Tuple2<int, int> range) {
    bool result = false;
    range.forEach((element) {
      if (pow(value, 1 / element) % 10 == 0) {
        result = true;
      }
    });
    return result;
  }

  ///Определяет, возможно ли разбить число на взятие процента в пределах допустимого диапазона
  bool _canSplitWithPercent(int value, Tuple2<int, int> range) {
    var result = false;
    // 50%(20)=10
    for (var i = 0.05; i <= 2; i += 0.05) {
      if (range.contains(value * i)) {
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
    return item1.toString() + " * " + item2.toString();
  }

  String _splitWithDivide(int value, Tuple2<int, int> range) {
    var divider = range.random();
    return (value * divider).toString() + " / " + divider.toString();
  }

  String _splitWithPow(int value, Tuple2<int, int> range) {
    range.forEach((i) {
      if (pow(value, 1 / i) % 10 == 0) {
        return pow(value, 1 / i).toInt().toString() + " ^ " + i.toString();
      }
    });
    throw Exception(
        "Произошла ошибка при разбиении числа на возведение в степень");
  }

  String _splitWithPercent(int value, Tuple2<int, int> range) {
    var allowedPercentValues = <double>[];
    for (var i = 0.05; i <= 2; i += 0.05) {
      //50%(20)=10
      if (range.contains(value / i)) {
        allowedPercentValues.add(i);
      }
    }
    var selectedPercent = allowedPercentValues.random();
    return (selectedPercent * 100).toString() +
        "%(" +
        (value / selectedPercent).toString() +
        ")";
  }

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

  void _incrementOperationCount(_CalculationAction operation) {
    var operationPrefString;
    switch (operation) {
      case (_CalculationAction.PLUS):
        {
          operationPrefString = PrefsValues.calcPlusCount;
        }
        break;
      case (_CalculationAction.MINUS):
        {
          operationPrefString = PrefsValues.calcMinusCount;
        }
        break;
      case (_CalculationAction.MULTIPLY):
        {
          operationPrefString = PrefsValues.calcMultiplyCount;
        }
        break;
      case (_CalculationAction.DIVIDE):
        {
          operationPrefString = PrefsValues.calcDivideCount;
        }
        break;
      case (_CalculationAction.POW):
        {
          operationPrefString = PrefsValues.calcPowCount;
        }
        break;
      case (_CalculationAction.PERCENT):
        {
          operationPrefString = PrefsValues.calcPercentCount;
        }
        break;
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(operationPrefString, prefs.getInt(operationPrefString) + 1);
    });
  }
}

extension TupleOperationsExtentions on Tuple2<int, int> {
  Tuple2<int, int> divide(num value) {
    return Tuple2(item1 ~/ value, item2 ~/ value);
  }

  int random() {
    var rand = Random();
    return rand.nextInt(item1 + item2) - item1;
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
}

class _CalculationAction extends Enum<String> {
  const _CalculationAction(String value) : super(value);

  static const PLUS = _CalculationAction("PLUS");
  static const MINUS = _CalculationAction("MINUS");
  static const MULTIPLY = _CalculationAction("MULTIPLY");
  static const DIVIDE = _CalculationAction("DIVIDE");
  static const PERCENT = _CalculationAction("PERCENT");
  static const POW = _CalculationAction("POW");
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
