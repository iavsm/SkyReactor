import 'package:flutter/material.dart';

class ElevatedLargeButton extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function onPressed;
  final EdgeInsets padding;

  const ElevatedLargeButton(
      {Key key, @required this.color, @required this.child, this.onPressed, this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPressed == null ? null : () => onPressed(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 62, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: child,
      ),
    );
  }
}
