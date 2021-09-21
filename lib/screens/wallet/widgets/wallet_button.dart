import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

class WalletButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const WalletButton({Key key, @required this.text, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: ShapeDecoration(
          color: kColorAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
