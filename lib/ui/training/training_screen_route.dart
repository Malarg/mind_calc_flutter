
import 'package:flutter/material.dart';
import 'package:mind_calc/ui/training/training_screen.dart';
import 'package:mind_calc/ui/training/training_screen_wm.dart';

class TrainingScreenRoute extends MaterialPageRoute {
  TrainingScreenRoute(TrainingType type) : super(builder: (ctx) => TrainingScreen(type));
}