import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/shared_widgets/detail_unit.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/helpers.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';

class StrategyCell extends StatelessWidget {
  final StrategyDetails strategy;

  const StrategyCell({Key key, @required this.strategy}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.strategyScreen, arguments: strategy),
      child: Container(
        width: size.width * 0.8,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 3,
              blurRadius: 3,
              color: Colors.black12.withOpacity(0.05),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: 80,
                height: 98,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Image.network(
                  strategy.strategyImage ?? kPlaceholderImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Sizer.horizontal(),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strategy.nickname,
                    style: textTheme.headline3.copyWith(fontSize: 16),
                  ),
                  Sizer.qtr(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: DetailUnit(title: 'Drawdown', value: strategy.details.drawdown)),
                      Sizer.horizontal(),
                      Flexible(
                          child:
                              DetailUnit(title: 'Total Pips', value: strategy.details.totalPips)),
                      Sizer.horizontal(),
                      Flexible(
                          child:
                              DetailUnit(title: 'Commission', value: strategy.details.commission)),
                    ],
                  ),
                  const Flexible(child: Sizer()),
                  Row(
                    children: [
                      DetailUnit(
                        title: 'Total Gain',
                        value: strategy.details.totalGain,
                        valueStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: strategy.details.totalGain == '-' ? kColorPrimary : Colors.green,
                          height: 1.1,
                        ),
                      ),
                      Sizer.horizontal32(),
                      DetailUnit(
                        title: 'Risk',
                        value: strategy.details.risk,
                        valueStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: riskColor(strategy.details.risk),
                          height: 1.1,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
