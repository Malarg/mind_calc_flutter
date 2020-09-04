import 'package:flutter/material.dart' hide Action;
import 'package:mind_calc/data/resources/assets.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/common/widgets/rounded_rectange_background.dart';
import 'package:mind_calc/ui/select_language/select_language_screen_wm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:tuple/tuple.dart';
import 'di/select_language_component.dart';
import 'di/select_language_wm_builder.dart';

///View
class SelectLanguageScreen extends MwwmWidget<SelectLanguageComponent> {
  SelectLanguageScreen({
    Key key,
  }) : super(
          widgetModelBuilder: createSelectLanguageWm,
          dependenciesBuilder: (context) => SelectLanguageComponent(context),
          widgetStateBuilder: () => _SelectLanguageWidgetState(),
        );
}

class _SelectLanguageWidgetState
    extends WidgetState<SelectLanguageWidgetModel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return StreamedStateBuilder(
      streamedState: wm.selectedLanguageState,
      builder: (c, selectedLangId) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                loc.main.selectLanguage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ProjectColors.dusc,
                  fontSize: 20,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            leading: FlatButton(
              onPressed: () {
                wm.backButtonPressedAction.accept();
              },
              child: Icon(Icons.arrow_back),
            ),
            actions: <Widget>[
              // временное решение
              Text("ddfdfdfff", style: TextStyle(color: Colors.transparent)),
            ],
            backgroundColor: ProjectColors.iceBlue,
          ),
          backgroundColor: ProjectColors.iceBlue,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildLanguageItem(
                  Assets.flag_english,
                  loc.main.english,
                  selectedLangId == ENGLISH_ID,
                  () {
                    wm.selectLanguageAction.accept(ENGLISH_ID);
                  },
                ),
                SizedBox(height: 12),
                _buildLanguageItem(
                  Assets.flag_russian,
                  loc.main.russian,
                  selectedLangId == RUSSIAN_ID,
                  () {
                    wm.selectLanguageAction.accept(RUSSIAN_ID);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(String asset, String languageName, bool isSelected,
      VoidCallback onPressed) {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: Colors.white,
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              color: ProjectColors.paleGrey28,
              child: Padding(
                padding: EdgeInsets.all(1),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: Image.asset(
                      asset,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 24),
          Text(
            languageName,
            style: TextStyle(
              color: ProjectColors.dusc,
              fontSize: 20,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            decoration: BoxDecoration(
              color: isSelected ? ProjectColors.ice : ProjectColors.closeWhite,
              borderRadius: BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: ProjectColors.tealishGreen,
                    )
                  : Container(),
            ),
          )
        ],
      ),
    );
  }
}
