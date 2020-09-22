import 'dart:async';
import 'package:flutter/material.dart' hide Action;
import 'package:get_storage/get_storage.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mind_calc/data/db/db_provider.dart';
import 'package:mind_calc/data/models/complexity.dart';
import 'package:mind_calc/ui/common/dialog/default_dialog_controller.dart';
import 'package:mind_calc/ui/select_language/select_language_route.dart';
import 'package:mwwm/mwwm.dart';
import 'package:mind_calc/ui/select_language/select_language_screen_wm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import '../../data/resources/prefs_values.dart';

/// [SettingsWidgetModel] для [SettingsScreen]
class SettingsWidgetModel extends WidgetModel {
  final NavigatorState _navigator;
  final DefaultDialogController dialogController;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  final StreamedState<bool> isPremiumEnabledState = StreamedState();

  final Action<void> changeLanguageAction = Action();
  final StreamedState<int> languageState = StreamedState();

  final StreamedState<int> complexityState = StreamedState(0);
  final StreamedState<bool> isComplexityEditModeState = StreamedState(false);

  final Action<void> showComplexityEditModeAction = Action();
  final Action<void> showComplexityDisplayModeAction = Action();

  final StreamedState<String> complexityTextFieldState = StreamedState("");
  final Action<String> complexityTextFieldChangedAction = Action();

  final StreamedState<bool> isMultiplyEnabledState = StreamedState();
  final StreamedState<bool> isDivideEnabledState = StreamedState();
  final StreamedState<bool> isPowEnabledState = StreamedState();
  final StreamedState<bool> isPercentEnabledState = StreamedState();

  final Action<void> multiplyButtonClickedAction = Action();
  final Action<void> divideButtonClickedAction = Action();
  final Action<void> powButtonClickedAction = Action();
  final Action<void> percentButtonClickedAction = Action();

  final StreamedState<bool> isEqualityModeEnabledState = StreamedState();
  final Action<bool> equalityModeChangedAction = Action();

  final StreamedState<bool> isNotificationsEnabled = StreamedState();
  final Action<bool> notificationEnabledChangedAction = Action();

  final StreamedState<ProductDetails> productDetails = StreamedState();
  final Action<void> buyProItemAction = Action();

  SettingsWidgetModel(WidgetModelDependencies dependencies, this._navigator,
      this.dialogController)
      : super(dependencies);

  @override
  void onLoad() async {
    super.onLoad();
    var prefs = GetStorage();
    isPremiumEnabledState.accept(prefs.read(PrefsValues.isProPurchaced));
    languageState.accept(prefs.read(PrefsValues.languageId) ?? ENGLISH_ID);

    int currentComplexity = prefs.read(PrefsValues.complexity);
    complexityState.accept(currentComplexity);
    complexityTextFieldState.accept(currentComplexity.toString());

    isMultiplyEnabledState.accept(prefs.read(PrefsValues.isMultiplyEnabled));
    isDivideEnabledState.accept(prefs.read(PrefsValues.isDivideEnabled));
    isPowEnabledState.accept(prefs.read(PrefsValues.isPowEnabled));
    isPercentEnabledState.accept(prefs.read(PrefsValues.isPercentEnabled));

    isEqualityModeEnabledState
        .accept(prefs.read(PrefsValues.isEqualityModeEnabled));

    var billingProducts = await InAppPurchaseConnection.instance
        .queryProductDetails({"pro_version"});
    if (billingProducts.productDetails.isNotEmpty) {
      var proMode = billingProducts.productDetails
          .firstWhere((e) => e.id == "pro_version");
      productDetails.accept(proMode);
      if (proMode.skuDetail.isRewarded ?? false) {
        prefs.write(PrefsValues.isProPurchaced, true);
        isPremiumEnabledState.accept(true);
      }
    } else {
      productDetails.accept(null);
    }
    var stream = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = stream.listen((purchases) {
      purchases.forEach((purchase) {
        if (purchase.pendingCompletePurchase) {
          InAppPurchaseConnection.instance.completePurchase(purchase);
          prefs.write(PrefsValues.isProPurchaced, true);
          isPremiumEnabledState.accept(true);
          _subscription.cancel();
        }
      });
    }, onDone: () {
      _subscription.cancel();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  void onBind() {
    super.onBind();
    bind(changeLanguageAction, (_) {
      _navigator.push(SelectLanguageRoute()).then((_) {
        var langId = GetStorage().read(PrefsValues.languageId);
        languageState.accept(langId);
      });
    });
    bind(showComplexityEditModeAction, (_) {
      isComplexityEditModeState.accept(true);
    });
    bind(showComplexityDisplayModeAction, (t) {
      isComplexityEditModeState.accept(false);
      if (complexityTextFieldChangedAction.value !=
          complexityTextFieldState.value) {
        var newComplexity = complexityTextFieldChangedAction.value != ""
            ? int.parse(complexityTextFieldChangedAction.value)
            : 1;
        complexityTextFieldState.accept(newComplexity.toString());
        complexityState.accept(newComplexity);
        GetStorage().write(PrefsValues.complexity, newComplexity);
        DBProvider.db
            .insertComplexity(Complexity(null, newComplexity, DateTime.now()));
      }
    });
    bind(notificationEnabledChangedAction, (value) {
      isNotificationsEnabled.accept(value);
    });
    bind(equalityModeChangedAction, (value) {
      isEqualityModeEnabledState.accept(value);
      GetStorage().write(PrefsValues.isEqualityModeEnabled, value);
    });
    bind(multiplyButtonClickedAction, (t) {
      var newValue = !GetStorage().read(PrefsValues.isMultiplyEnabled);
      GetStorage().write(PrefsValues.isMultiplyEnabled, newValue);
      isMultiplyEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(divideButtonClickedAction, (t) {
      var newValue = !GetStorage().read(PrefsValues.isDivideEnabled);
      GetStorage().write(PrefsValues.isDivideEnabled, newValue);
      isDivideEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(powButtonClickedAction, (t) {
      var newValue = !GetStorage().read(PrefsValues.isPowEnabled);
      GetStorage().write(PrefsValues.isPowEnabled, newValue);
      isPowEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });
    bind(percentButtonClickedAction, (t) {
      var newValue = !GetStorage().read(PrefsValues.isPercentEnabled);
      GetStorage().write(PrefsValues.isPercentEnabled, newValue);
      isPercentEnabledState.accept(newValue);
      _setZeroActionsCounters();
    });

    bind(buyProItemAction, (_) {
      InAppPurchaseConnection.instance.buyNonConsumable(
        purchaseParam: PurchaseParam(
          productDetails: productDetails.value,
        ),
      );
    });
  }

  _setZeroActionsCounters() {
    GetStorage().write(PrefsValues.calcPlusCount, 0);
    GetStorage().write(PrefsValues.calcMinusCount, 0);
    GetStorage().write(PrefsValues.calcMultiplyCount, 0);
    GetStorage().write(PrefsValues.calcDivideCount, 0);
    GetStorage().write(PrefsValues.calcPowCount, 0);
    GetStorage().write(PrefsValues.calcPercentCount, 0);
  }
}
