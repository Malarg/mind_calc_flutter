import 'package:injector/injector.dart';
import 'package:flutter/material.dart';

///Компонент экрана истории
class HistoryScreenComponent implements Component {
  NavigatorState navigator;

  HistoryScreenComponent(BuildContext context) {
    navigator = Navigator.of(context);
  }
}