import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../training_screen_wm.dart';

/// Компонент экрана тренировки
class TrainingScreenComponent implements Component {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TrainingType type;
  NavigatorState navigator;

  TrainingScreenComponent(BuildContext context, TrainingType type)
      : this.type = type {
    navigator = Navigator.of(context);
  }
}
