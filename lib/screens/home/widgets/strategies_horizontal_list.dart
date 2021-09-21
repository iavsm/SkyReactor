import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/screens/home/widgets/strategy_cell.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';

class StrategiesHorizontalList extends StatelessWidget {
  final List<StrategyDetails> strategies;

  const StrategiesHorizontalList({Key key, @required this.strategies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (cxt, index) {
          return StrategyCell(strategy: strategies[index]);
        },
        itemCount: strategies?.length ?? 0,
        separatorBuilder: (cxt, index) => Sizer.halfHorizontal(),
      ),
    );
  }
}
