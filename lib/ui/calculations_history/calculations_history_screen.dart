import 'package:flutter/material.dart' hide Action;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injector/injector.dart';
import 'package:mind_calc/data/models/calculation.dart';
import 'package:mind_calc/data/models/training.dart';
import 'package:mind_calc/data/resources/assets.dart';
import 'package:mind_calc/data/resources/colors.dart';
import 'package:mind_calc/generated/locale_base.dart';
import 'package:mind_calc/ui/common/widgets/calculation_history_item.dart';
import 'package:path/path.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

import 'calculations_history_screen_wm.dart';
import 'di/calculations_history_screen_component.dart';
import 'di/calculations_history_screen_wm_builder.dart';

///Экран истории вычислений в тренировке
class CalculationsHistoryScreen
    extends MwwmWidget<CalculationsHistoryComponent> {
  CalculationsHistoryScreen(
    Training training, {
    Key key,
  }) : super(
          widgetModelBuilder: createCalculationsHistoryWm,
          dependenciesBuilder: (context) =>
              CalculationsHistoryComponent(context, training),
          widgetStateBuilder: () => _CalculationsHistoryWidgetState(),
        );
}

class _CalculationsHistoryWidgetState
    extends WidgetState<CalculationsHistoryWidgetModel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<LocaleBase>(context, LocaleBase);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            loc.main.history,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ProjectColors.dusc,
              fontSize: 20,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: FlatButton(
          onPressed: () {
            wm.backClickedAction.accept();
          },
          child: Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          // временное решение. Изменится после добавления статистики
          Text("ddfdfdfff", style: TextStyle(color: Colors.transparent)),
        ],
        backgroundColor: ProjectColors.iceBlue,
      ),
      backgroundColor: ProjectColors.iceBlue,
      body: SingleChildScrollView(
          child: StreamedStateBuilder(
        streamedState: wm.calculationsState,
        builder: (_, obj) {
          if (obj == null) {
            return Container();
          }
          var training = obj.item1 as Training;
          var calcs = obj.item2 as List<Calculation>;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(calcs.length, (i) {
                return CalculationHistoryItem(
                  calculation: calcs[i],
                  prevTime: i > 0 ? calcs[i - 1].timestamp : training.startTime,
                );
              }),
            ),
          );
        },
      )),
    );
  }
}
