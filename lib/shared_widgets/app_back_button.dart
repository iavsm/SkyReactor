import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.maybePop(context),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.keyboard_arrow_left_outlined),
            Flexible(child: Sizer.qtrHorizontal()),
            const AutoSizeText('Back'),
          ],
        ),
      ),
    );
  }
}
