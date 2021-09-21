import 'package:copy_trading/shared_widgets/phone_input_widget/src/models/country_model.dart';
import 'package:copy_trading/shared_widgets/phone_input_widget/src/utils/util.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

// ignore_for_file: unnecessary_this
// ignore_for_file: prefer_final_locals
// ignore_for_file: prefer_const_constructors_in_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: constant_identifier_names
/// [Item]
class Item extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final bool useEmoji;
  final TextStyle textStyle;
  final bool withCountryNames;

  const Item({
    Key key,
    this.country,
    this.showFlag,
    this.useEmoji,
    this.textStyle,
    this.withCountryNames = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 2),
          _Flag(
            country: country,
            showFlag: showFlag,
            useEmoji: useEmoji,
          ),
          SizedBox(width: 9),
          SizedBox(
            width: 1,
            height: 20,
            child: VerticalDivider(
              color: kColorLightGrey,
              width: 1,
              thickness: 2,
              indent: 0,
              endIndent: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country country;
  final bool showFlag;
  final bool useEmoji;

  const _Flag({Key key, this.country, this.showFlag, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null && showFlag
        ? Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: useEmoji
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headline5,
                  )
                : country?.flagUri != null
                    ? Image.asset(
                        country?.flagUri,
                        width: 32.0,
                        package: 'intl_phone_number_input',
                      )
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}
