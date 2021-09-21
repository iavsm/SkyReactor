import 'package:copy_trading/models/chart_data.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../strategy_view_model.dart';

class AppChart extends StatelessWidget {
  final ChartData chartData;
  final StatsType type;
  final double barWidth;
  const AppChart({
    Key key,
    @required this.chartData,
    @required this.type,
    this.barWidth = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Iterable<int> values = chartData?.dataList?.data?.map((e) => e.value.round()) ?? [];
    final bool hasDataToShow = values.isNotEmpty &&
        values.firstWhere((element) => element > 0, orElse: () => null) != null;
    return !hasDataToShow
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
            child: Row(
              children: [
                Text(
                  type == StatsType.balance ? '\$0' : '0%',
                  style: const TextStyle(
                      color: kColorPrimary, fontSize: 10, fontWeight: FontWeight.w600),
                ),
                Sizer.horizontal(),
                const Expanded(
                  child: Divider(
                    thickness: 0.5,
                    color: kColorPrimary,
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 40),
            child: SizedBox(
              width: values.length * barWidth + 50,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  barTouchData: BarTouchData(
                    enabled: true,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: SideTitles(
                      showTitles: false,
                      getTextStyles: (value) => const TextStyle(color: Colors.black, fontSize: 10),
                      margin: 10,
                      rotateAngle: 0,
                      getTitles: (double value) {
                        switch (value.toInt()) {
                          case 1:
                            return 'Jan';
                          case 2:
                            return 'Feb';
                          case 3:
                            return 'Mar';
                          case 4:
                            return 'Apr';
                          case 5:
                            return 'May';
                          case 6:
                            return 'Jun';
                          case 7:
                            return 'Jul';
                          case 8:
                            return 'Aug';
                          case 9:
                            return 'Sep';
                          case 10:
                            return 'Oct';
                          case 11:
                            return 'Nov';
                          case 12:
                            return 'Dec';
                          default:
                            return '';
                        }
                      },
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) => const TextStyle(
                          color: kColorPrimary, fontSize: 10, fontWeight: FontWeight.w600),
                      getTitles: (double value) {
                        final String valueToShow = value.toInt().toString();
                        return type == StatsType.balance ? '\$$valueToShow' : '$valueToShow%';
                      },
                      checkToShowTitle: (minValue, maxValue, titles, interval, value) {
                        return values.contains(value);
                      },
                      interval: 1,
                      margin: 20,
                      reservedSize: 40,
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 1,
                    checkToShowHorizontalLine: (value) {
                      return value == 0;
                    },
                    getDrawingHorizontalLine: (value) {
                      if (value == 0) {
                        return FlLine(color: kColorPrimary, strokeWidth: 0.5);
                      }
                      return FlLine(
                        color: kColorPrimary,
                        strokeWidth: 0,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  groupsSpace: 4,
                  barGroups: [
                    ...chartData.dataList.data
                        .map((e) => BarChartGroupData(
                              barsSpace: 6,
                              x: e.date.month,
                              barRods: [
                                BarChartRodData(
                                  y: e.value.round().toDouble(),
                                  width: barWidth,
                                  colors: [kColorAccent],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(e.value > 0 ? 6 : 0),
                                      topRight: Radius.circular(e.value > 0 ? 6 : 0),
                                      bottomLeft: Radius.circular(e.value > 0 ? 0 : 6),
                                      bottomRight: Radius.circular(e.value > 0 ? 0 : 6)),
                                ),
                              ],
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          );
  }
}
