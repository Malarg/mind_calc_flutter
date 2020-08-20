import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/data/models/training.dart';

class TrainingResultScreenComponent implements Component {
  NavigatorState navigator;
  final Training training;

  TrainingResultScreenComponent(BuildContext context, this.training) {
    navigator = Navigator.of(context);
  }
}