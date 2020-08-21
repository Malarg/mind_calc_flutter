
import 'package:flutter/material.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/ui/pause/pause_screen.dart';

class PauseScreenRoute extends MaterialPageRoute {
  PauseScreenRoute(Training training) : super(builder: (ctx) => PauseScreen(training));
}