import 'package:copy_trading/screens/strategies_list/strategies_list_view_model.dart';
import 'package:copy_trading/screens/strategies_list/widgets/filter_button.dart';
import 'package:copy_trading/screens/strategies_list/widgets/strategy_short_cell.dart';
import 'package:copy_trading/shared_widgets/app_back_button.dart';
import 'package:copy_trading/shared_widgets/app_bar_sign_in_button.dart';
import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:copy_trading/shared_widgets/home_sign_in_button.dart';
import 'package:copy_trading/shared_widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StrategiesListScreen extends StatefulWidget {
  final String title;
  final String type;

  const StrategiesListScreen({Key key, @required this.title, @required this.type})
      : super(key: key);

  @override
  _StrategiesListScreenState createState() => _StrategiesListScreenState();
}

class _StrategiesListScreenState extends State<StrategiesListScreen> {
  static const filters = ['1w', '1m', '3m', '6m', '12m'];
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (cxt, watch, _) {
        final listViewModel = watch(strategiesListProvider(widget.type));
        return Scaffold(
          appBar: AppBar(
            leading: AppBackButton(),
            leadingWidth: 75,
            actions: [
              AppBarSignInButton(),
            ],
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  sliver: SliverToBoxAdapter(
                    child: HomeSignInButton(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...filters
                            .map((e) => FilterButton(
                                  value: e,
                                  active: listViewModel.activeFilter == e,
                                  onTap: () {
                                    listViewModel.applyFilter(e);
                                  },
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 10),
                    child: SectionTitleWidget(title: widget.title),
                  ),
                ),
                if (listViewModel.loading) ...[
                  SliverFillRemaining(
                    child: DefaultLoader(),
                  )
                ] else ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (cxt, index) {
                        if (index == listViewModel.strategies.length - 1) {
                          listViewModel.getList();
                        }

                        return StrategyShortCell(strategy: listViewModel.strategies[index]);
                      },
                      childCount: listViewModel.strategies.length,
                    ),
                  ),
                  if (listViewModel.loadingMore) ...[
                    SliverToBoxAdapter(
                      child: DefaultLoader(),
                    ),
                  ]
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
