import 'package:mwwm/mwwm.dart';
import 'package:flutter/widgets.dart' as w;

class AppWidgetModel extends WidgetModel {
  final w.GlobalKey<w.NavigatorState> _navigator;

  AppWidgetModel(
    WidgetModelDependencies baseDependencies, 
    this._navigator
  ) : super(baseDependencies);

  @override
  void onLoad() {
    super.onLoad();
  }
}