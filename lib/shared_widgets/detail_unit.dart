import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/util/helpers.dart';
import 'package:flutter/material.dart';

class DetailUnit extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle valueStyle;
  final bool isShort;
  final EdgeInsets padding;

  const DetailUnit({
    Key key,
    @required this.title,
    @required this.value,
    this.valueStyle,
    this.padding,
    this.isShort = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String valueToShow = value;
    if (title == 'Drawdown') {
      valueToShow = '$value%';
    }
    if (title == 'Total Gain') {
      valueToShow = (value == '-')
          ? value
          : isMinus(value)
              ? '-\$${value.substring(1)}'
              : '\$$value';
    }
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: isShort ? const EdgeInsets.symmetric(horizontal: 5) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: value == '-' ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            title,
            maxLines: 1,
            minFontSize: 6,
            textAlign: TextAlign.center,
            style: textTheme.subtitle2.copyWith(fontWeight: FontWeight.normal, height: 1),
          ),
          SizedBox(height: isShort ? 6 : 2),
          AutoSizeText(
            valueToShow,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: valueStyle ?? textTheme.bodyText2.copyWith(height: 1.3, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
