import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final Function onPressed;
  final EdgeInsetsGeometry padding;

  const SectionTitleWidget({
    Key key,
    @required this.title,
    this.onPressed,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              title ?? '',
              style: textTheme.headline4.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (onPressed != null) ...[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onPressed(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'See All',
                    style: textTheme.caption,
                  ),
                  Sizer.qtrHorizontal(),
                  const Icon(Icons.arrow_forward_ios_outlined, size: 10),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
