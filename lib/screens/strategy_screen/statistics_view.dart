import 'package:carousel_slider/carousel_slider.dart';
import 'package:copy_trading/models/stats_details.dart';
import 'package:copy_trading/screens/strategy_screen/strategy_view_model.dart';
import 'package:copy_trading/screens/strategy_screen/widgets/app_chart.dart';
import 'package:copy_trading/screens/strategy_screen/widgets/stat_cell.dart';
import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:copy_trading/shared_widgets/section_title_widget.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Statistics extends StatefulWidget {
  final String strategyName;

  const Statistics({Key key, @required this.strategyName}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final DateFormat monthFormatter = DateFormat('MMM');

  Widget statsContainer({@required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10, right: 15),
      padding: const EdgeInsets.symmetric(vertical: 10),
      height: 205,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 5,
            blurRadius: 5,
            color: Colors.black12.withOpacity(0.04),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      ),
    );
  }

  Widget monthFilterButton(
      {@required String title, bool selected = false, @required Function onPressed}) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: title == 'All Months' ? 14 : 10, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? kColorLightGrey : kColorBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kColorLightGrey),
          ),
          child: Text(
            title,
            style: selected
                ? textTheme.headline4.copyWith(fontSize: 12)
                : textTheme.subtitle2.copyWith(fontSize: 12),
          ),
        ),
      ),
    );
  }

  String _statsChartTitle(StatsType type) {
    switch (type) {
      case StatsType.growth:
        return 'Growth';
        break;
      case StatsType.profit:
        return 'Profit';
        break;
      case StatsType.balance:
        return 'Balance';
        break;
      default:
        return 'Growth';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (cxt, watch, _) {
        final StrategyViewModel strategyViewModel = watch(strategyProvider(widget.strategyName));
        final StatsDetails statsDetails = strategyViewModel.statsDetails;
        return strategyViewModel.loading
            ? DefaultLoader()
            : Expanded(
                child: SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 10),
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          viewportFraction: 0.9,
                          onPageChanged: (index, _) {
                            strategyViewModel.clearFilters();
                            switch (index) {
                              case 0:
                                strategyViewModel.getChart(StatsType.growth,
                                    firstFetch: strategyViewModel.growthData == null);
                                break;
                              case 1:
                                strategyViewModel.getChart(StatsType.profit,
                                    firstFetch: strategyViewModel.profitData == null);
                                break;
                              case 2:
                                strategyViewModel.getChart(StatsType.balance,
                                    firstFetch: strategyViewModel.balanceData == null);
                                break;
                            }
                          },
                        ),
                        items: [
                          statsContainer(
                            children: [
                              StatCell(
                                  title: 'Gain %:',
                                  value: '+${statsDetails?.gain ?? ''}%',
                                  valueColor: Colors.green),
                              StatCell(
                                  title: 'Daily Gain %:',
                                  value: '+${statsDetails?.dailyGain ?? ''}%',
                                  valueColor: Colors.green),
                              StatCell(
                                  title: 'Monthly Gain %:',
                                  value: '${statsDetails?.monthlyGain ?? ''}%'),
                              StatCell(title: 'Drawdown:', value: statsDetails?.drawdown ?? ''),
                              StatCell(
                                  title: 'Account Age:', value: statsDetails?.accountAge ?? ''),
                            ],
                          ),
                          statsContainer(
                            children: [
                              StatCell(
                                  title: 'Balance:',
                                  value: '+${statsDetails?.balance ?? ''}%',
                                  valueColor: Colors.green),
                              StatCell(
                                  title: 'Equity:',
                                  value: '+${statsDetails?.equity ?? ''}%',
                                  valueColor: Colors.green),
                              StatCell(
                                  title: 'Profit/Loss:',
                                  value: '${statsDetails?.profitLoss ?? ''}%'),
                              StatCell(title: 'Deposit:', value: '${statsDetails?.deposit ?? ''}%'),
                              StatCell(
                                  title: 'Withdrawal:',
                                  value: '${statsDetails?.withdrawal ?? ''}%'),
                            ],
                          ),
                          statsContainer(
                            children: [
                              StatCell(
                                  title: 'Trades:',
                                  value: '+${statsDetails?.trades ?? ''}',
                                  valueColor: Colors.green),
                              StatCell(
                                  title: 'Profit Factor:',
                                  value: '+${statsDetails?.profitFactor ?? ''}%',
                                  valueColor: Colors.green),
                              StatCell(title: 'PIPS:', value: '${statsDetails?.pips ?? ''}%'),
                              StatCell(title: 'Lots:', value: '${statsDetails?.lots ?? ''}%'),
                              StatCell(
                                  title: 'Average Win:',
                                  value: '${statsDetails?.averageWin ?? ''}%'),
                              StatCell(
                                  title: 'Average Loss:',
                                  value: '${statsDetails?.averageLoss ?? ''}%'),
                              StatCell(
                                  title: 'Short/Long Position:',
                                  value: statsDetails?.shortLongPosition ?? ''),
                              StatCell(
                                  title: 'Short/Long Won:',
                                  value: statsDetails?.shortLongWon ?? ''),
                              StatCell(
                                  title: 'Average Trade Length:',
                                  value: '${statsDetails?.averageTradeLength ?? ''}%'),
                            ],
                          ),
                        ],
                      ),
                      Sizer.vertical24(),
                      SectionTitleWidget(title: _statsChartTitle(strategyViewModel.selectedChart)),
                      if (strategyViewModel.selectedChartData != null ||
                          strategyViewModel.chartLoading) ...[
                        if (strategyViewModel.availableChartYears.isNotEmpty) ...[
                          Sizer.half(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                ...strategyViewModel.availableChartYears.reversed
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.only(right: 25),
                                          child: GestureDetector(
                                            onTap: () {
                                              strategyViewModel.setChartYear(e);
                                            },
                                            child: Text(
                                              e.year.toString(),
                                              style: TextStyle(
                                                color: strategyViewModel.selectedYearDate?.year ==
                                                        e.year
                                                    ? kColorPrimary
                                                    : kColorGrey,
                                                fontWeight:
                                                    strategyViewModel.selectedYearDate?.year ==
                                                            e.year
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ],
                            ),
                          ),
                        ],
                        if (strategyViewModel.availableChartMonths.isNotEmpty) ...[
                          Sizer.half(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                monthFilterButton(
                                    title: 'All Months',
                                    selected: strategyViewModel.selectedMonthDate == null,
                                    onPressed: () {
                                      strategyViewModel.setChartMonth(null);
                                    }),
                                ...strategyViewModel.availableChartMonths.map((e) =>
                                    monthFilterButton(
                                        title: monthFormatter.format(e),
                                        selected:
                                            strategyViewModel.selectedMonthDate?.month == e.month,
                                        onPressed: () {
                                          strategyViewModel.setChartMonth(e);
                                        }))
                              ],
                            ),
                          ),
                        ],
                        if (strategyViewModel.chartLoading) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: DefaultLoader(),
                          ),
                        ] else ...[
                          const Sizer(),
                          AppChart(
                              chartData: strategyViewModel.selectedChartData,
                              type: strategyViewModel.selectedChart),
                        ],
                      ],
                    ],
                  ),
                ),
              );
      },
    );
  }
}
