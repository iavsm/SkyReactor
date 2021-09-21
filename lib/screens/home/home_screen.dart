import 'package:copy_trading/providers/strategy_list_provider.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/screens/home/widgets/strategies_horizontal_list.dart';
import 'package:copy_trading/shared_widgets/app_bar_sign_in_button.dart';
import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:copy_trading/shared_widgets/elevated_large_button.dart';
import 'package:copy_trading/shared_widgets/home_sign_in_button.dart';
import 'package:copy_trading/shared_widgets/section_title_widget.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Consumer(
      builder: (cxt, watch, _) {
        final strategiesViewModel = watch(strategyListProvider);
        return Scaffold(
          appBar: AppBar(
            title: const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text('Copy Trading'),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              AppBarSignInButton(),
            ],
          ),
          bottomNavigationBar: RaisedButton(
            onPressed: () {},
            elevation: 20,
            color: Colors.white,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: bottomPadding > 10 ? 0 : 10),
                child: Text(
                  'Start',
                  style: textTheme.headline4,
                ),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.only(top: 16, bottom: 50),
            children: [
              HomeSignInButton(),
              const Sizer(),
              if (strategiesViewModel.loading) ...[
                DefaultLoader(),
              ] else ...[
                if (strategiesViewModel.strategyList.topGainers != null) ...[
                  SectionTitleWidget(
                    title: strategiesViewModel.strategyList.topGainers?.title,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.strategiesList,
                      arguments: {
                        'title': strategiesViewModel.strategyList.topGainers.title,
                        'type': 'topgainers'
                      },
                    ),
                  ),
                  StrategiesHorizontalList(
                      strategies: strategiesViewModel.strategyList.topGainers?.strategies),
                  Sizer.vertical24(),
                ],
                if (strategiesViewModel.strategyList.mostPopular != null) ...[
                  SectionTitleWidget(
                    title: strategiesViewModel.strategyList.mostPopular?.title,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.strategiesList,
                      arguments: {
                        'title': strategiesViewModel.strategyList.mostPopular.title,
                        'type': 'mostpopular'
                      },
                    ),
                  ),
                  StrategiesHorizontalList(
                      strategies: strategiesViewModel.strategyList.mostPopular?.strategies),
                ],
                Sizer.vertical24(),
              ],
              ElevatedLargeButton(
                onPressed: () => Navigator.pushNamed(context, Routes.register),
                color: kColorPrimary,
                padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 20),
                child: Text(
                  'Create Account With Leoprime',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Sizer.vertical24(),
              if (!strategiesViewModel.loading) ...[
                if (strategiesViewModel.strategyList.commission != null) ...[
                  SectionTitleWidget(
                    title: strategiesViewModel.strategyList.commission?.title,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.strategiesList,
                      arguments: {
                        'title': strategiesViewModel.strategyList.commission.title,
                        'type': 'commission'
                      },
                    ),
                  ),
                  StrategiesHorizontalList(
                      strategies: strategiesViewModel.strategyList.commission?.strategies),
                  Sizer.vertical24(),
                ],
                if (strategiesViewModel.strategyList.drawdown != null) ...[
                  SectionTitleWidget(
                    title: strategiesViewModel.strategyList.drawdown?.title,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.strategiesList,
                      arguments: {
                        'title': strategiesViewModel.strategyList.drawdown.title,
                        'type': 'drawdown'
                      },
                    ),
                  ),
                  StrategiesHorizontalList(
                      strategies: strategiesViewModel.strategyList.drawdown?.strategies),
                  Sizer.vertical24(),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
