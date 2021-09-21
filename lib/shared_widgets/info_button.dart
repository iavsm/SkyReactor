import 'package:copy_trading/screens/strategy_screen/widgets/info_position_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoButton extends StatelessWidget {
  final String info;
  final Direction direction;
  final Widget infoWidget;

  const InfoButton({Key key, this.info, this.infoWidget, this.direction = Direction.down})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        if (infoWidget == null) {
          context.read(infoPositionProvider).showBubble(details, info, direction);
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: infoWidget,
                  titlePadding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              });
        }
      },
      child: SizedBox(
        width: 18,
        height: 18,
        child: Image.asset('assets/icons/info-icon.png'),
      ),
    );
  }
}
