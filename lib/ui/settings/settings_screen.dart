import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/common/widgets/rounded_rectange_background.dart';
import 'package:mind_calc/ui/select_language/select_language_screen_wm.dart';
import 'package:mind_calc/ui/settings/settings_screen_wm.dart';
import 'package:share/share.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:mwwm/mwwm.dart';
import 'di/settings_screen_component.dart';
import 'di/settings_screen_wm_builder.dart';

///View
class SettingsScreen extends MwwmWidget<SettingsScreenComponent> {
  SettingsScreen({
    Key key,
  }) : super(
          key: key,
          widgetModelBuilder: createSettingsScreenWm,
          dependenciesBuilder: (context) => SettingsScreenComponent(context),
          widgetStateBuilder: () => _SettingsWidgetState(),
        );
}

class _SettingsWidgetState extends WidgetState<SettingsWidgetModel> {
  var textController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return StreamedStateBuilder(
      streamedState: wm.isPremiumEnabledState,
      builder: (_, isPremiumEnabled) {
        return StreamedStateBuilder(
            streamedState: wm.languageState,
            builder: (c, langId) {
              return Scaffold(
                appBar: AppBar(
                  title: Center(
                    child: Text(
                      loc.main.settings,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ProjectColors.dusc,
                        fontSize: 20,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  backgroundColor: ProjectColors.iceBlue,
                ),
                backgroundColor: ProjectColors.iceBlue,
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildLanguageItem(langId),
                        SizedBox(height: 12),
                        _buildComplexityItem(isPremiumEnabled),
                        SizedBox(height: 12),
                        _buildEqualityModeItem(isPremiumEnabled),
                        SizedBox(height: 12),
                        //_buildNotificationsItem(),
                        //SizedBox(height: 12),
                        _buildAllowedOperationsItem(isPremiumEnabled),
                        SizedBox(height: 24),
                        _buildBuyProItem(context),
                        SizedBox(height: 12),
                        _buildShareItem()
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  Widget _buildLanguageItem(int langId) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    var langString = "";
    switch (langId) {
      case ENGLISH_ID:
        {
          langString = loc.main.english;
        }
        break;
      case RUSSIAN_ID:
        {
          langString = loc.main.russian;
        }
    }
    return RoundedRectangeBackground(
      child: Row(
        children: <Widget>[
          Text(
            "${loc.main.language}: $langString",
            style: TextStyle(
              color: ProjectColors.duscTwo,
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            height: 36,
            width: 48,
            child: FlatButton(
              onPressed: () {
                wm.changeLanguageAction.accept();
              },
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              color: ProjectColors.warmBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Icon(
                Icons.mode_edit,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplexityItem(bool isPremiumEnabled) {
    return StreamedStateBuilder(
      streamedState: wm.isComplexityEditModeState,
      builder: (_, isEditMode) {
        if (isEditMode) {
          return _buildComplexityEditModeState();
        } else {
          return _buildComplexityDisplayModeState(isPremiumEnabled);
        }
      },
    );
  }

  Widget _buildComplexityEditModeState() {
    return RoundedRectangeBackground(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
        child: Row(
          children: <Widget>[
            StreamedStateBuilder(
              streamedState: wm.complexityTextFieldState,
              builder: (_, text) {
                textController.text = text;
                return SizedBox(
                  width: 40,
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: ProjectColors.greenBlue,
                      fontSize: 16,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onEditingComplete: () {
                      wm.showComplexityDisplayModeAction();
                    },
                    onChanged: (text) {
                      wm.complexityTextFieldChangedAction.accept(text);
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: Container(),
            ),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              height: 36,
              width: 48,
              child: FlatButton(
                onPressed: () {
                  wm.showComplexityDisplayModeAction();
                },
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                color: ProjectColors.greenBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildComplexityDisplayModeState(bool isPremiumEnabled) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return RoundedRectangeBackground(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Row(
        children: <Widget>[
          Text(
            "${loc.main.complexityLevel}",
            style: TextStyle(
              color: ProjectColors.duscTwo,
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          if (!isPremiumEnabled) _buildProLabel(),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            width: 8,
          ),
          StreamedStateBuilder(
            streamedState: wm.complexityState,
            builder: (_, value) {
              return Text(
                value.toString(),
                style: TextStyle(
                  color: ProjectColors.darkSkyBlue,
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          SizedBox(
            width: 16,
          ),
          SizedBox(
            height: 36,
            width: 48,
            child: FlatButton(
              onPressed: () {
                if (isPremiumEnabled) {
                  wm.showComplexityEditModeAction();
                }
              },
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              color: isPremiumEnabled
                  ? ProjectColors.warmBlue
                  : ProjectColors.cloudyBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Icon(
                Icons.mode_edit,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEqualityModeItem(bool isPremiumEnabled) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return RoundedRectangeBackground(
      padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
      child: Row(
        children: <Widget>[
          Text(
            "${loc.main.equalityMode}",
            style: TextStyle(
              color: ProjectColors.duscTwo,
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          if (!isPremiumEnabled) _buildProLabel(),
          Expanded(
            child: Container(),
          ),
          StreamedStateBuilder(
            streamedState: wm.isEqualityModeEnabledState,
            builder: (_, isEnabled) {
              if (isEnabled == null) {
                return Container();
              }
              return Switch(
                value: isEnabled,
                onChanged: (bool value) {
                  if (isPremiumEnabled) {
                    wm.equalityModeChangedAction.accept(value);
                  }
                },
                activeColor: ProjectColors.greenBlue,
                inactiveThumbColor: ProjectColors.iceBlue,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsItem() {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return RoundedRectangeBackground(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "${loc.main.notifications}",
                style: TextStyle(
                  color: ProjectColors.duscTwo,
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
              Expanded(
                child: Container(),
              ),
              StreamedStateBuilder(
                streamedState: wm.isNotificationsEnabled,
                builder: (_, isEnabled) {
                  return Switch(
                    value: isEnabled ?? false,
                    onChanged: (bool value) {
                      wm.notificationEnabledChangedAction.accept(value);
                    },
                    activeColor: ProjectColors.greenBlue,
                    inactiveThumbColor: ProjectColors.iceBlue,
                  );
                },
              ),
            ],
          ),
          StreamedStateBuilder(
              streamedState: wm.isNotificationsEnabled,
              builder: (_, isEnabled) {
                return isEnabled ?? false ? SizedBox(height: 16) : Container();
              }),
          StreamedStateBuilder(
            streamedState: wm.isNotificationsEnabled,
            builder: (context, isEnabled) {
              return isEnabled ?? false
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "${loc.main.remindTraining}",
                            style: TextStyle(
                              color: ProjectColors.duscTwo,
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Text(
                            "12:00",
                            style: TextStyle(
                              color: ProjectColors.darkSkyBlue,
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 12),
                          SizedBox(
                            height: 36,
                            width: 48,
                            child: FlatButton(
                              onPressed: () {},
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              color: ProjectColors.warmBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Icon(
                                Icons.mode_edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAllowedOperationsItem(bool isPremiumEnabled) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return RoundedRectangeBackground(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "${loc.main.allowedOperations}",
                style: TextStyle(
                  color: ProjectColors.duscTwo,
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              if (!isPremiumEnabled) _buildProLabel(),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              SizedBox(
                width: 64,
                child: StreamedStateBuilder(
                  streamedState: wm.isMultiplyEnabledState,
                  builder: (_, isEnabled) {
                    return FlatButton(
                      onPressed: () {
                        if (isPremiumEnabled) {
                          wm.multiplyButtonClickedAction.accept();
                        }
                      },
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      color: getActionColor(isEnabled, isPremiumEnabled),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        "∗",
                        style: TextStyle(
                          color: isEnabled
                              ? Colors.white
                              : ProjectColors.cloudyBlue,
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 64,
                child: StreamedStateBuilder(
                  streamedState: wm.isDivideEnabledState,
                  builder: (_, isEnabled) {
                    return FlatButton(
                      onPressed: () {
                        if (isPremiumEnabled) {
                          wm.divideButtonClickedAction.accept();
                        }
                      },
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      color: getActionColor(isEnabled, isPremiumEnabled),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        "÷",
                        style: TextStyle(
                          color: isEnabled
                              ? Colors.white
                              : ProjectColors.cloudyBlue,
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 64,
                child: StreamedStateBuilder(
                  streamedState: wm.isPowEnabledState,
                  builder: (_, isEnabled) {
                    return FlatButton(
                      onPressed: () {
                        if (isPremiumEnabled) {
                          wm.powButtonClickedAction.accept();
                        }
                      },
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      color: getActionColor(isEnabled, isPremiumEnabled),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        "x ^ y",
                        style: TextStyle(
                          color: isEnabled
                              ? Colors.white
                              : ProjectColors.cloudyBlue,
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
              SizedBox(
                width: 64,
                child: StreamedStateBuilder(
                  streamedState: wm.isPercentEnabledState,
                  builder: (_, isEnabled) {
                    return FlatButton(
                      onPressed: () {
                        if (isPremiumEnabled) {
                          wm.percentButtonClickedAction.accept();
                        }
                      },
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      color: getActionColor(isEnabled, isPremiumEnabled),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        "%",
                        style: TextStyle(
                          color: isEnabled
                              ? Colors.white
                              : ProjectColors.cloudyBlue,
                          fontSize: 14,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color getActionColor(bool isEnabled, isPremiumEnabled) {
    if (isEnabled ?? false) {
      if (isPremiumEnabled) {
        return ProjectColors.warmBlue;
      } else {
        return ProjectColors.cloudyBlue;
      }
    } else {
      return ProjectColors.paleGrey28;
    }
  }

  Widget _buildBuyProItem(BuildContext _context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return FlatButton(
      onPressed: () {
        showModalBottomSheet(
            context: _context,
            isScrollControlled: true,
            builder: (context) {
              return StreamedStateBuilder(
                  streamedState: wm.productDetails,
                  builder: (_, proItem) {
                    if (proItem == null) {
                      return _buildBuyProNotAvailable();
                    } else {
                      return _buildBuyProBottomSheet();
                    }
                  });
            });
      },
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      color: ProjectColors.salmonPink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Text(
        loc.main.getProVersion,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildBuyProNotAvailable() {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    final titlesTextStyle = TextStyle(
      color: ProjectColors.duscTwo,
      fontSize: 20,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w700,
    );
    final descTextStyle = TextStyle(
      color: ProjectColors.duscTwo,
      fontSize: 14,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w400,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 44, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            loc.main.proNotAvailable,
            textAlign: TextAlign.left,
            style: titlesTextStyle,
          ),
          SizedBox(height: 24),
          Text(loc.main.proNotAvailableDesc, style: descTextStyle),
        ],
      ),
    );
  }

  Widget _buildBuyProBottomSheet() {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    final titlesTextStyle = TextStyle(
      color: ProjectColors.duscTwo,
      fontSize: 16,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w700,
    );
    final descTextStyle = TextStyle(
      color: ProjectColors.duscTwo,
      fontSize: 14,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w400,
    );
    return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 44, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              loc.main.proVersionBsTitle,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: ProjectColors.duscTwo,
                fontSize: 20,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 24),
            Text(loc.main.disableAds, style: titlesTextStyle),
            Text(
              loc.main.disableAdsDesc,
              style: descTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(loc.main.percentTitle, style: titlesTextStyle),
            Text(
              loc.main.percentDesc,
              style: descTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(loc.main.changeComplexity, style: titlesTextStyle),
            Text(
              loc.main.changeComplexityDesc,
              style: descTextStyle,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 40),
            FlatButton(
              onPressed: () {
                wm.buyProItemAction.accept();
              },
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              color: ProjectColors.purpleishBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: Text(
                loc.main.buyPro,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildShareItem() {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return FlatButton(
      onPressed: () {
        Share.share("text");
      },
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      color: ProjectColors.pinkishOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Text(
        loc.main.shareFriends,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildProLabel() {
    return RoundedRectangeBackground(
      padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
      child: Text(
        "PRO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w700,
        ),
      ),
      color: ProjectColors.salmonPink,
    );
  }
}
