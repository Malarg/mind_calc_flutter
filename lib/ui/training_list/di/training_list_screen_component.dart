import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

/// Компонент виджета списка тренировок
class TrainingListScreenComponent implements Component {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  NavigatorState navigator;

  TrainingListScreenComponent(BuildContext context) {
    navigator = Navigator.of(context);
  }
}
