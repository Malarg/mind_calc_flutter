import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mind_calc/ui/main/di/main_screen_component.dart';
import 'package:mind_calc/ui/main/di/main_screen_wm_builder.dart';
import 'package:mind_calc/ui/main/main_screen_wm.dart';
import 'package:mind_calc/ui/training_list/training_list_screen.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:mind_calc/data/resources/assets.dart';
import 'package:mind_calc/data/resources/colors.dart';

/// Главный экран приложения
class MainScreen extends MwwmWidget<MainScreenComponent> {
  MainScreen({
    Key key,
    WidgetModelBuilder wmBuilder = createMainScreenWm,
  }) : super(
          key: key,
          widgetStateBuilder: () => _MainScreenState(),
          widgetModelBuilder: wmBuilder,
          dependenciesBuilder: (context) => MainScreenComponent(context),
        );
}

/// Состояние главного экрана приложения
class _MainScreenState extends WidgetState<MainScreenWidgetModel> {
  static const BOTTOM_BAR_ANIMATION_SPEED_COEF = 0.2;

  var trainingListScreen = TrainingListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamedStateBuilder<MainScreenTabType>(
        streamedState: wm.selectedPageState,
        builder: (BuildContext context, MainScreenTabType state) {
          return Center(
            child: state == MainScreenTabType.TRAINING
                ? trainingListScreen
                : Text(state.value.toString()),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  FluidNavBar _buildBottomNavigationBar() {
    return FluidNavBar(
      animationFactor: BOTTOM_BAR_ANIMATION_SPEED_COEF,
      icons: _buildBottomNavigationBarItems(),
      style: FluidNavBarStyle(
          iconSelectedForegroundColor: ProjectColors.warmBlue,
          iconUnselectedForegroundColor: ProjectColors.cloudyBlue),
      onChange: _onBottomBarItemSelected,
    );
  }

  List<FluidNavBarIcon> _buildBottomNavigationBarItems() {
    return [
      FluidNavBarIcon(iconPath: Assets.workout),
      FluidNavBarIcon(iconPath: Assets.history),
      FluidNavBarIcon(iconPath: Assets.settings),
    ];
  }

  void _onBottomBarItemSelected(int selectedIndex) {
    wm.menuItemSelectedAction.accept(selectedIndex);
  }
}
