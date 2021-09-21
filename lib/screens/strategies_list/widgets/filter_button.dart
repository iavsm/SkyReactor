import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final bool active;
  final String value;
  final Function onTap;

  const FilterButton({Key key, @required this.active, @required this.value, @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: active ? kColorAccent : null,
        ),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
