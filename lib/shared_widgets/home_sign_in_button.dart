import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

import 'elevated_large_button.dart';

class HomeSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedLargeButton(
      onPressed: () => Navigator.pushNamed(context, Routes.login),
      color: kColorAccent,
      child: Column(
        children: [
          Text(
            'Sign In',
            style: textTheme.headline5.copyWith(fontSize: 19),
          ),
          const SizedBox(height: 10),
          Text(
            'Sign-in into your registered account & start\ncopying positions of verified traders.',
            textAlign: TextAlign.center,
            style: textTheme.bodyText1.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
