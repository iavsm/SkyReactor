import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/screens/strategy_screen/strategy_view_model.dart';
import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:copy_trading/shared_widgets/section_title_widget.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/detail_cell.dart';

class Overview extends ConsumerWidget {
  final String strategyName;

  const Overview({Key key, @required this.strategyName}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final StrategyViewModel strategyViewModel = watch(strategyProvider(strategyName));
    final StrategyDetails strategyDetails = strategyViewModel.strategyDetails;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return strategyViewModel.loading
        ? DefaultLoader()
        : Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: 30, top: (strategyDetails.about?.isNotEmpty ?? false) ? 20 : 10),
              child: Column(
                children: [
                  if (strategyDetails.about?.isNotEmpty ?? false) ...[
                    Text(
                      'About',
                      style: textTheme.headline3.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Sizer.half(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        strategyDetails.about,
                        textAlign: TextAlign.center,
                        style:
                            textTheme.bodyText2.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),
                    Sizer.vertical24(),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SectionTitleWidget(title: 'Details'),
                  ),
                  Sizer.half(),
                  DetailCell(
                    title: 'Balance',
                    value: strategyDetails.details.overview.balance,
                    info:
                        'Balance refers to the strategy\nproviders’ total account balance,\nincluding the profits & the losses.',
                  ),
                  DetailCell(
                    title: 'Equity',
                    value: strategyDetails.details.overview.equity,
                    info:
                        'Equity considers only the profits and\nlosses of the strategy providers’\naccount and displays the total fund\nvalue available.',
                  ),
                  DetailCell(
                    title: 'Profit & Loss',
                    value: strategyDetails.details.overview.profitLoss,
                    info: 'This refers to the strategy providers’\nreal-time net profit and loss.',
                  ),
                  DetailCell(
                    title: 'Leverage',
                    value: strategyDetails.details.overview.leverage,
                    info:
                        'Leverage refers to the ratio between\nthe strategy provider’s own funds & the\nmoney/capital amount borrowed.',
                  ),
                  DetailCell(
                    title: 'Minimum Deposit',
                    value: strategyDetails.details.overview.deposit.minimum,
                    info:
                        'A minimum deposit is the minimum/\ninitial amount of money that is deposited\nto copy a traders’ strategy.',
                  ),
                  DetailCell(
                    title: 'Recommended Deposit',
                    value: strategyDetails.details.overview.deposit.recommended,
                    info:
                        'The strategy provider advises/\nrecommends the investor to deposit a\nparticular amount while copying his/her\npositions, to gain better results.',
                  ),
                ],
              ),
            ),
          );
  }
}
