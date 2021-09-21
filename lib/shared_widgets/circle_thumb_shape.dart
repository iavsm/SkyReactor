import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

class CircleThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const CircleThumbShape({this.thumbRadius = 6.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      TextPainter labelPainter,
      RenderBox parentBox,
      Size sizeWithOverflow,
      SliderThemeData sliderTheme,
      TextDirection textDirection,
      double textScaleFactor,
      Thumb thumb,
      double value}) {
    final Canvas canvas = context.canvas;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = sliderTheme.thumbColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, fillPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);

    final TextSpan span = TextSpan(
        style: const TextStyle(color: kColorPrimary), text: (value * 100).floor().toString());
    final TextPainter tp =
        TextPainter(text: span, textAlign: TextAlign.center, textDirection: textDirection);
    tp.layout();
    tp.paint(canvas, center.translate(_getTranslationX(value), -thumbRadius / 2));
  }

  double _getTranslationX(double value) {
    if (value < 0.1) return -thumbRadius / 3;
    if (0.1 <= value && value < 1.0) return -thumbRadius / 1.8;
    return -thumbRadius / 1.2;
  }
}
