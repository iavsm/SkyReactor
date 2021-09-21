import 'package:auto_size_text/auto_size_text.dart';
import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/shared_widgets/detail_unit.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/helpers.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';

class StrategyShortCell extends StatelessWidget {
  final StrategyDetails strategy;

  const StrategyShortCell({Key key, @required this.strategy}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.pushNamed(context, Routes.strategyScreen, arguments: strategy);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.network(
                strategy.strategyImage ?? kPlaceholderImageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Sizer.horizontal(),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AutoSizeText(
                          strategy.nickname,
                          maxLines: 1,
                          style: textTheme.headline3,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Gain: ',
                            style: textTheme.subtitle2.copyWith(fontSize: 12),
                          ),
                          Text(
                            strategy.details.gainPercentage == '-'
                                ? '-'
                                : '${strategy.details.gainPercentage}%',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                                height: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    endIndent: 0,
                    indent: 0,
                  ),
                  Sizer.half(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: DetailUnit(
                            title: 'Drawdown', value: strategy.details.drawdown, isShort: true),
                      ),
                      Flexible(
                        child: DetailUnit(
                            title: 'Total Pips', value: strategy.details.totalPips, isShort: true),
                      ),
                      Flexible(
                        child: DetailUnit(
                            title: 'Commission', value: strategy.details.commission, isShort: true),
                      ),
                      Flexible(
                        child: DetailUnit(
                            title: 'Risk',
                            value: strategy.details.risk,
                            valueStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                              color: riskColor(strategy.details.risk),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
