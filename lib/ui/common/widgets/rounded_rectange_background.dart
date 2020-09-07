import 'package:flutter/material.dart';

class RoundedRectangeBackground extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  RoundedRectangeBackground({
    @required this.child,
    this.color = Colors.white,
    this.padding = const EdgeInsets.fromLTRB(24, 16, 24, 12),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.child,
      padding: padding,
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
    );
  }
}
