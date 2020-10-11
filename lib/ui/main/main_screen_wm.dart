import 'package:firebase_admob/firebase_admob.dart';
import 'package:mind_calc/data/db/db_provider.dart';
import 'package:mind_calc/ui/common/ads/ad_manager.dart';
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
  void onLoad() async {
    super.onLoad();
  await FirebaseAdMob.instance.initialize(appId: AdManager.appId);
    await DBProvider.db.database;
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
