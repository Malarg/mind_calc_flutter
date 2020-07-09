import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

///Компонент главного экрана приложения
class MainScreenComponent implements Component {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  NavigatorState navigator;

  MainScreenComponent(BuildContext context) {
    navigator = Navigator.of(context);
  }
}
