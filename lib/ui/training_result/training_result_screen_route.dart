import 'package:flutter/material.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/ui/training_result/training_result_screen.dart';

class TrainingResultScreenRoute extends MaterialPageRoute {
  TrainingResultScreenRoute(Training training)
      : super(builder: (ctx) => TrainingResultScreen(training));
}
