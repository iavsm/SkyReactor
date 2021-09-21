import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/models/activity_details.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../util/helpers.dart';

class ActivityCell extends StatefulWidget {
  final ActivityDetails activityDetails;

  const ActivityCell({Key key, @required this.activityDetails}) : super(key: key);
  @override
  _ActivityCellState createState() => _ActivityCellState();
}

class _ActivityCellState extends State<ActivityCell> {
  bool expanded = false;
  final DateFormat dateFormat = DateFormat('HH:mm');

  Widget dataUnit(String title, String value) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      height: 25,
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: textTheme.subtitle2.copyWith(fontSize: 13, color: kColorPrimary),
            ),
          ),
          Sizer.horizontal(),
          if (value?.isNotEmpty ?? false) ...[
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  value,
                  style: textTheme.headline4.copyWith(fontSize: 14),
                ),
              ),
            ),
          ] else ...[
            const Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.lock,
                  color: kColorLightGrey,
                  size: 20,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ActivityDetails activity = widget.activityDetails;
    return Column(
      children: [
        ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(activity.ticket,
                style: textTheme.headline4.copyWith(
                  fontSize: 15,
                )),
          ),
          subtitle: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: 'Time: ',
                style: textTheme.subtitle2.copyWith(fontSize: 12, fontWeight: FontWeight.normal),
              ),
              TextSpan(
                text: dateFormat.format(activity.date),
                style: textTheme.headline4.copyWith(fontSize: 14),
              ),
            ]),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              expanded
                  ? const Icon(
                      Icons.keyboard_arrow_up,
                      color: kColorPrimary,
                    )
                  : const Icon(
                      Icons.keyboard_arrow_down,
                      color: kColorPrimary,
                    ),
              Sizer.half(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Symbol: ',
                    style:
                        textTheme.subtitle2.copyWith(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: activity.symbol,
                    style: textTheme.headline4.copyWith(fontSize: 14),
                  ),
                ]),
              ),
            ],
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          onExpansionChanged: (value) {
            setState(() {
              expanded = value;
            });
          },
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dataUnit('Type:', activity.type.capitalize()),
                      dataUnit('Volume:', activity.size),
                      dataUnit('Price:', activity.openPrice),
                      dataUnit('S/L:', activity.sl),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dataUnit('T/P:', activity.tp),
                      dataUnit('Swap:', activity.swaps),
                      dataUnit('Profit:', activity.profit),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        if (!expanded) ...[
          const Divider(
            endIndent: 20,
            indent: 20,
          ),
        ]
      ],
    );
  }
}
