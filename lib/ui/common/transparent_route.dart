import 'package:flutter/material.dart';

/// Роут с прозрачным фоном
/// Использовать если нужен роут с прозрачным фоном,
/// чтобы не перекрывать UI предыдущего роута
class TransparentRoute extends PageRoute<void> {
  /// Билдинг контента
  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  final bool dismissable;

  TransparentRoute({
    @required this.builder,
    RouteSettings settings,
    this.dismissable,
    bool opaque,
    this.transitionDuration = const Duration(milliseconds: 350),
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  /// Цвет [ModalBarrier] если null, то цвет будет прозрачным
  @override
  Color get barrierColor => null;

  /// Затенять ли предыдущие маршруты после завершения перехода
  @override
  bool get opaque => false;

  /// Можно ли закрыть этот роут, по тапу на фон
  @override
  bool get barrierDismissible => dismissable;

  /// Семантическая метка для [ModalBarrier]
  @override
  String get barrierLabel => null;

  /// Должен ли маршрут оставаться в памяти, когда он неактивен
  @override
  bool get maintainState => true;

  /// Создание содержимого маршрута
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: builder(context),
      ),
    );
  }
}
