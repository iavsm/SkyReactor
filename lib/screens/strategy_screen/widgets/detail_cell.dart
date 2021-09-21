import 'package:copy_trading/screens/strategy_screen/widgets/info_position_provider.dart';
import 'package:copy_trading/shared_widgets/info_button.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';

class DetailCell extends StatelessWidget {
  final String title;
  final String value;
  final String info;

  const DetailCell({Key key, @required this.title, @required this.value, this.info})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool upDirection = title == 'Minimum Deposit' || title == 'Recommended Deposit';
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 30),
            title: Row(
              children: [
                Text(
                  title,
                  style: textTheme.headline6.copyWith(fontSize: 13, fontWeight: FontWeight.w400),
                ),
                if (info != null) ...[
                  Sizer.halfHorizontal(),
                  InfoButton(info: info, direction: upDirection ? Direction.up : Direction.down),
                ],
              ],
            ),
            trailing: Text(
              value,
              style: textTheme.headline4.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const Divider(
            endIndent: 30,
            indent: 30,
          ),
        ],
      ),
    );
  }
}
