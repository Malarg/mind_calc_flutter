
import 'package:flutter/material.dart';
import 'package:mind_calc/data/models/training.dart';
import 'calculations_history_screen.dart';

class CalculationsHistoryScreenRoute extends MaterialPageRoute {
  CalculationsHistoryScreenRoute(Training training) : super(builder: (ctx) => CalculationsHistoryScreen(training));
}