import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/common/dialog/dialog_owner.dart';
import 'package:mind_calc/ui/settings/settings_screen_wm.dart';
import 'package:mwwm/src/controller/dialog_controller.dart';

class SettingsScreenDialogOwner with DialogOwner {
  @override
  Map<dynamic, DialogBuilder<DialogData>> get registeredDialogs => {
        SettingsDialogType.PRO_PUCHASED:
            DialogBuilder<DialogData>(_buildProPurchasedDialog),
        SettingsDialogType.RESTORE_NOT_AVAILABLE:
            DialogBuilder<DialogData>(_buildRestoreNotAvailableDialog),
        SettingsDialogType.ERROR_PURCHASE_PRO:
        DialogBuilder<DialogData>(_buildPurchaseProErrorDialog),
        SettingsDialogType.POW_AND_PERCENT_INFO:
        DialogBuilder<DialogData>(_buildPowAndPercentInfoDialog),
      };

    Widget _buildPurchaseProErrorDialog(
    BuildContext context, {
    DialogData data,
  }) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return _buildShowInfoBottomSheet(
        context, loc.main.error, loc.main.buyProErrorDesc);
  }

  Widget _buildProPurchasedDialog(
    BuildContext context, {
    DialogData data,
  }) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return _buildShowInfoBottomSheet(
        context, loc.main.congratilations, loc.main.proPurchased);
  }

  Widget _buildRestoreNotAvailableDialog(
    BuildContext context, {
    DialogData data,
  }) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return _buildShowInfoBottomSheet(
        context, loc.main.error, loc.main.restoreNotAvailable);
  }

  Widget _buildPowAndPercentInfoDialog(
    BuildContext context, {
    DialogData data,
  }) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return _buildShowInfoBottomSheet(
        context, loc.main.powAndPercentsTitle, loc.main.powAndPercentsDescription);
  }

  Widget _buildShowInfoBottomSheet(
    BuildContext context,
    String title,
    String description,
  ) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 44, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: ProjectColors.duscTwo,
                fontSize: 20,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 24),
            Text(
              description,
              style: TextStyle(
                color: ProjectColors.duscTwo,
                fontSize: 14,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.justify,
            ),
            Expanded(child: Container()),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              color: ProjectColors.purpleishBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: Text(
                loc.main.close,
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
}
