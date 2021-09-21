import 'package:copy_trading/screens/strategy_screen/widgets/info_position_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MyBubbleClipper extends CustomClipper<Path> {
  final double radius;
  final double offset;
  final double nipSize;
  final Direction direction;

  MyBubbleClipper({this.radius = 15, this.offset = 10, this.nipSize = 4, this.direction});

  @override
  Path getClip(Size size) {
    final bool up = direction == Direction.up;
    final path = Path();
    path.addRRect(
        RRect.fromLTRBR(0, 0, size.width, size.height + nipSize, Radius.circular(radius)));

    final path2 = Path();
    path2.lineTo(45, 0);
    path2.lineTo(50, up ? nipSize : -nipSize);
    path2.lineTo(55, 0);
    path2.close();

    path.addPath(
      path2,
      Offset(up ? 40 : 10, up ? size.height + nipSize : 0),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
