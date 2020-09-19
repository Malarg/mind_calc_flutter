import 'package:flutter/material.dart';
import 'package:mind_calc/data/resources/prefs_values.dart';
import 'package:mind_calc/generated/locale_base.dart';

import 'package:get_storage/get_storage.dart';
import 'package:mind_calc/ui/select_language/select_language_screen_wm.dart';

///Делегат для локализации
class LocDelegate extends LocalizationsDelegate<LocaleBase> {
  const LocDelegate();
  final idMap = const {'ru': 'locales/RU.json', 'en': 'locales/EN_US.json'};

  @override
  bool isSupported(Locale locale) => ['ru', 'en'].contains(locale.languageCode);

  @override
  Future<LocaleBase> load(Locale locale) async {
    var langId = GetStorage().read(PrefsValues.languageId) ?? ENGLISH_ID;
    var langPath = getLocalizationPath(langId);
    final loc = LocaleBase();
    await loc.load(langPath);
    return loc;
  }

  @override
  bool shouldReload(LocDelegate old) => false;
}

String getLocalizationPath(int langId) {
  var languagePath = ENGLISH_PATH;
  switch (langId) {
    case ENGLISH_ID:
      {
        languagePath = ENGLISH_PATH;
      }
      break;
    case RUSSIAN_ID:
      {
        languagePath = RUSSIAN_PATH;
      }
      break;
    default:
      {
        languagePath = ENGLISH_PATH;
      }
      break;
  }
  return languagePath;
}
