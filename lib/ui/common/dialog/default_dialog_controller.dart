import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_calc/ui/common/dialog/alert/flutter_alert.dart';
import 'package:mind_calc/ui/common/dialog/dialog_owner.dart';
import 'package:mind_calc/ui/common/transparent_route.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_util/surf_util.dart';

/// Типы сообщений
class DialogType extends Enum<String> {
  const DialogType(String value) : super(value);

  static const alert = DialogType('alert');
}

///Стандартная реализация [DialogController]
class DefaultDialogController implements DialogController {
  final GlobalKey<ScaffoldState> _scaffoldState;
  final BuildContext _context;
  final DialogOwner dialogOwner;

  PersistentBottomSheetController _sheetController;

  DefaultDialogController(this._scaffoldState, {this.dialogOwner})
      : _context = null;

  DefaultDialogController.from(this._context, {this.dialogOwner})
      : _scaffoldState = null;

  BuildContext get _scaffoldContext {
    return _scaffoldState?.currentContext ?? Scaffold.of(_context).context;
  }

  @Deprecated(
      'Вместо этого метода нужно использовать showPlatformAlertDialog')
  @override
  Future<R> showAlertDialog<R>({
    String title,
    String message,
    onAgreeClicked,
    onDisagreeClicked,
  }) {
    throw Exception('Метод не поддерживается');
  }

  /// Показывает alert dialog в зависимости от платформы
  void showPlatformAlertDialog({
    String title,
    String body,
    List<AlertAction> actions,
    bool barrierDismissible,
    bool cancelable = false,
  }) {
    showAlert(
      context: _scaffoldContext,
      title: title,
      body: body,
      actions: actions,
      barrierDismissible: barrierDismissible,
      cancelable: cancelable,
    );
  }

  /// Скрывает диалог используя его [route]
  void dismissDialog(Route route) {
    if (!route.isActive) return;
    Navigator.of(_scaffoldContext).removeRoute(route);
  }

  @override
  Future<R> showSheet<R>(
    type, {
    VoidCallback onDismiss,
    DialogData data,
    Color backgroundColor,
  }) {
    assert(dialogOwner != null);

    final buildDialog = dialogOwner?.registeredDialogs[type];

    if (_scaffoldState == null) {
      _sheetController = showBottomSheet(
        context: _context,
        builder: (ctx) => buildDialog(ctx, data: data),
        backgroundColor: backgroundColor ?? Colors.transparent,
      );
    } else {
      _sheetController = _scaffoldState.currentState.showBottomSheet(
        (ctx) => buildDialog(ctx, data: data),
        backgroundColor: backgroundColor ?? Colors.transparent,
      );
    }

    _sheetController.closed.then((_) {
      _sheetController = null;
      onDismiss();
    });

    return _sheetController.closed;
  }

  @override
  Future<R> showModalSheet<R>(
    type, {
    VoidCallback onDismiss,
    DialogData data,
    bool isScrollControlled = false,
  }) {
    assert(dialogOwner != null);

    return showModalBottomSheet(
      context: _scaffoldContext,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (ctx) => dialogOwner?.registeredDialogs[type](ctx, data: data),
    );
  }
}

/// Дефолтный диалог выбора даты
class DatePickerDialogController {
  final GlobalKey<ScaffoldState> _scaffoldState;
  final BuildContext _context;

  DatePickerDialogController(this._scaffoldState) : _context = null;

  DatePickerDialogController.from(this._context) : _scaffoldState = null;

  BuildContext get _scaffoldContext =>
      _scaffoldState?.currentContext ?? Scaffold.of(_context).context;

  Stream<DateTime> show({
    DateTime firstDate,
    DateTime lastDate,
    DateTime initialDate,
    Widget iosCloseButton,
    Widget iosDoneButton,
  }) {
    if (Theme.of(_scaffoldContext).platform == TargetPlatform.android) {
      return showDatePicker(
        context: _scaffoldContext,
        firstDate: firstDate ?? DateTime(1900),
        initialDate: initialDate,
        lastDate: lastDate ?? DateTime(2090),
      ).asStream();
    } else {
      StreamController<DateTime> controller = StreamController<DateTime>();
      showCupertinoModalPopup(
        context: _scaffoldContext,
        builder: (ctx) => _buildBottomPicker(
          CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: initialDate ?? DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              controller.add(newDateTime);
            },
          ),
          onCancel: () {
            controller.add(initialDate);
            controller.close();
            Navigator.of(_scaffoldContext, rootNavigator: true).pop();
          },
          onDone: () {
            controller.close();
            Navigator.of(_scaffoldContext, rootNavigator: true).pop();
          },
          iosCloseButton: iosCloseButton,
          iosDoneButton: iosDoneButton,
        ),
      );
      return controller.stream;
    }
  }

  Widget _buildBottomPicker(
    Widget picker, {
    VoidCallback onCancel,
    VoidCallback onDone,
    Widget iosCloseButton,
    Widget iosDoneButton,
  }) {
    return Container(
      height: 266,
      color: CupertinoColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              iosCloseButton ??
                  CupertinoButton(
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      "Сбросить",
                      style: TextStyle(color: CupertinoColors.destructiveRed),
                    ),
                    onPressed: onCancel,
                    color: Colors.transparent,
                  ),
              iosDoneButton ??
                  CupertinoButton(
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      "Готово",
                      style: TextStyle(color: CupertinoColors.activeBlue),
                    ),
                    onPressed: onDone,
                    color: Colors.transparent,
                  ),
            ],
          ),
          Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            color: CupertinoColors.white,
            child: DefaultTextStyle(
              style: const TextStyle(
                color: CupertinoColors.black,
                fontSize: 22.0,
              ),
              child: GestureDetector(
                // Blocks taps from propagating to the modal sheet and popping.
                onTap: () {},
                child: SafeArea(
                  top: false,
                  child: picker,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
