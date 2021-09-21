import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

class StatCell extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const StatCell({Key key, @required this.title, @required this.value, this.valueColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              title,
              style: textTheme.subtitle2.copyWith(
                fontSize: 12,
                color: kColorPrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
            AutoSizeText(
              value,
              style: textTheme.headline4.copyWith(
                fontSize: 13,
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
