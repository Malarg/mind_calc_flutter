import 'package:mwwm/mwwm.dart';
import 'package:surf_util/surf_util.dart';
import 'package:relation/relation.dart';

/// [WidgetModel] главного экрана
class MainScreenWidgetModel extends WidgetModel {
  final menuItemSelectedAction = Action<int>();
  final selectedPageState =
      StreamedState<MainScreenTabType>(MainScreenTabType.TRAINING);

  MainScreenWidgetModel(WidgetModelDependencies baseDependencies)
      : super(baseDependencies);

  @override
  void onLoad() {
    super.onLoad();
    _bindActions();
  }

  void _bindActions() {
    subscribe<int>(
      menuItemSelectedAction.stream,
      (int index) =>
          {selectedPageState.accept(MainScreenTabType.byValue(index))},
    );
  }
}

/// Типы табов на главном экране
class MainScreenTabType extends Enum<int> {
  const MainScreenTabType(int value) : super(value);

  static const MainScreenTabType TRAINING = MainScreenTabType(0);
  static const MainScreenTabType HISTORY = MainScreenTabType(1);
  static const MainScreenTabType SETTINGS = MainScreenTabType(2);

  static MainScreenTabType byValue(int value) {
    switch (value) {
      case 0:
        return TRAINING;
      case 1:
        return HISTORY;
      case 2:
        return SETTINGS;
      default:
        return TRAINING;
    }
  }
}
