import 'package:injector/injector.dart';
import 'package:flutter/material.dart';
import 'package:mind_calc/data/models/training.dart';

/// [Component] для [CalculationsHistory]
class CalculationsHistoryComponent implements Component {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  NavigatorState navigator;
  Training training;

  CalculationsHistoryComponent(BuildContext context, this.training) {
    navigator = Navigator.of(context);
  }
}
