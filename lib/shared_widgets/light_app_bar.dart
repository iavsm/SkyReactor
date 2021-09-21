import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

class LightAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Size size;
  final String title;

  const LightAppBar({Key key, this.size, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      brightness: Brightness.light,
      title: Text(
        title ?? '',
        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 14),
      ),
      iconTheme: const IconThemeData(
        color: kColorPrimary,
      ),
    );
  }

  @override
  Size get preferredSize => size ?? const Size(double.infinity, 44);
}
