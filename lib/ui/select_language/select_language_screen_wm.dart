import 'package:flutter/material.dart' hide Action;
import 'package:get_storage/get_storage.dart';
import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:mind_calc/domain/locale/loc_delegate.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

const ENGLISH_PATH = "locales/EN_US.json";
const RUSSIAN_PATH = "locales/RU.json";

const ENGLISH_ID = 1;
const RUSSIAN_ID = 2;

/// [SelectLanguageWidgetModel] для [SelectLanguage]
/// В префах будет храниться id текущего языка
/// 1 - Английский
/// 2 - Русский
class SelectLanguageWidgetModel extends WidgetModel {
  final NavigatorState _navigator;
  final BuildContext _parentContext;

  Action<void> backButtonPressedAction = Action();

  Action<int> selectLanguageAction = Action();
  StreamedState<int> selectedLanguageState = StreamedState();

  SelectLanguageWidgetModel(
    WidgetModelDependencies dependencies,
    this._navigator,
    this._parentContext,
  ) : super(dependencies);

  @override
  void onLoad() {
    super.onLoad();
    selectedLanguageState.accept(GetStorage().read(PrefsValues.languageId));
  }

  @override
  void onBind() {
    super.onBind();

    bind(backButtonPressedAction, (_) {
      _navigator.pop(_parentContext);
    });

    bind(selectLanguageAction, (selectedLangId) async {
      final loc = Localizations.of<LocaleBase>(_parentContext, LocaleBase);
      String languagePath = getLocalizationPath(selectedLangId);
      await loc.load(languagePath);
      selectedLanguageState.accept(selectedLangId);
      GetStorage().write(PrefsValues.languageId, selectedLangId);
    });
  }
}
