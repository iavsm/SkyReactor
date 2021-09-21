import 'package:copy_trading/router/route_names.dart';
import 'package:flutter/material.dart';

class AppBarSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return FlatButton(
      onPressed: () => Navigator.pushNamed(context, Routes.login),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        'Sign In',
        style: textTheme.bodyText1,
      ),
    );
  }
}
