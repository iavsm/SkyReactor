import 'package:flutter/material.dart';

enum BubbleType { sendBubble, receiverBubble }

class ChatBubble extends StatelessWidget {
  final CustomClipper<Path> clipper;
  final Widget child;
  final EdgeInsetsGeometry margin;
  final double elevation;
  final Color backGroundColor;
  final Color shadowColor;
  final Alignment alignment;

  const ChatBubble({
    this.clipper,
    this.child,
    this.margin,
    this.elevation,
    this.backGroundColor,
    this.shadowColor,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.topLeft,
      margin: margin ?? const EdgeInsets.all(0),
      child: PhysicalShape(
        clipper: clipper,
        elevation: elevation ?? 2,
        color: backGroundColor ?? Colors.blue,
        shadowColor: shadowColor ?? Colors.grey.shade200,
        child: Padding(
          padding: setPadding(),
          child: child ?? Container(),
        ),
      ),
    );
  }

  EdgeInsets setPadding() {
    return const EdgeInsets.all(10);
  }
}
