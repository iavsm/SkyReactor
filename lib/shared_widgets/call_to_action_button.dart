import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

class CallToActionButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  final Widget child;
  final bool loading;

  const CallToActionButton(
      {Key key, @required this.onPressed, this.child, this.title, this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: SizedBox(
        height: 47,
        width: double.infinity,
        child: RaisedButton(
          onPressed: loading ? () {} : () => onPressed(),
          color: kColorAccent,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: loading
              ? FittedBox(child: LightLoader())
              : title != null
                  ? Text(
                      title,
                      style: textTheme.button.copyWith(fontSize: 15),
                    )
                  : (child ?? const SizedBox()),
        ),
      ),
    );
  }
}
