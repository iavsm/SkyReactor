import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/screens/strategy_screen/statistics_view.dart';
import 'package:copy_trading/screens/strategy_screen/strategy_view_model.dart';
import 'package:copy_trading/screens/strategy_screen/activity_view.dart';
import 'package:copy_trading/screens/strategy_screen/overview_view.dart';
import 'package:copy_trading/screens/strategy_screen/widgets/info_position_provider.dart';
import 'package:copy_trading/screens/strategy_screen/widgets/my_bubble_clipper.dart';
import 'package:copy_trading/shared_widgets/app_back_button.dart';
import 'package:copy_trading/shared_widgets/app_bar_sign_in_button.dart';
import 'package:copy_trading/shared_widgets/error_dialog.dart';
import 'package:copy_trading/shared_widgets/info_button.dart';
import 'package:copy_trading/shared_widgets/tab_selection_widget.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:copy_trading/util/helpers.dart';
import 'package:copy_trading/util/sizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/chat_bubble.dart';

class StrategyScreen extends ConsumerWidget {
  final StrategyDetails strategy;

  const StrategyScreen({Key key, @required this.strategy}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final strategyViewModel = watch(strategyProvider(strategy.nickname));
    final infoBubbleViewModel = watch(infoPositionProvider);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Copy Trading',
              style: textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            leading: AppBackButton(),
            leadingWidth: 75,
            actions: [
              AppBarSignInButton(),
            ],
          ),
          body: Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 70,
                        color: kColorPrimary,
                      ),
                      Container(
                        width: double.infinity,
                        height: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Container(
                                  width: 80,
                                  height: 100,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    strategy.strategyImage ?? kPlaceholderImageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Sizer.horizontal(),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Sizer.vertical24(),
                                    Text(
                                      strategy.nickname,
                                      style: textTheme.headline5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 25,
                                              height: 20,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Image.network(
                                                strategy.country.flag,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Sizer.halfHorizontal(),
                                            Text(
                                              strategy.country.name,
                                              style: textTheme.headline6.copyWith(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                InfoButton(
                                                  infoWidget: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Risk Score',
                                                        style: textTheme.headline4,
                                                      ),
                                                      const Sizer(),
                                                      const Text(
                                                        'The level of risk you take is reflected in the risk score. When the  score goes higher. it means the risk is greater and there are high chances of making & losing money quickly. While copying trades, always be aware of the risk score as it keeps changing from time to time.',
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      const Sizer(),
                                                      Text(
                                                        'Low 1-5',
                                                        style: textTheme.headline4
                                                            .copyWith(fontSize: 12),
                                                      ),
                                                      Sizer.half(),
                                                      const Text(
                                                        'There are considerably low chances of losing all the capital in a short span of time',
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      const Sizer(),
                                                      Text(
                                                        'Medium 6-8',
                                                        style: textTheme.headline4
                                                            .copyWith(fontSize: 12),
                                                      ),
                                                      Sizer.half(),
                                                      const Text(
                                                        'Be very careful and always try to take responsibility for your losses',
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      const Sizer(),
                                                      Text(
                                                        'High 9-10',
                                                        style: textTheme.headline4
                                                            .copyWith(fontSize: 12),
                                                      ),
                                                      Sizer.half(),
                                                      const Text(
                                                        'Pay more attention and try to use only the capital you can afford to lose',
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      Sizer.vertical24(),
                                                    ],
                                                  ),
                                                ),
                                                Sizer.qtrHorizontal(),
                                                Text(
                                                  'Risk',
                                                  style: textTheme.subtitle2,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              strategy.details.risk,
                                              style: TextStyle(
                                                color: riskColor(strategy.details.risk),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                height: 1.3,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TabSelectionWidget(
                        onSelected: (index) {
                          TabView view;
                          switch (index) {
                            case 0:
                              view = TabView.overview;
                              break;
                            case 1:
                              view = TabView.stats;
                              break;
                            case 2:
                              view = TabView.activity;
                              break;
                          }
                          strategyViewModel.changeView(view);
                        },
                        children: const [
                          Text('Overview'),
                          Text('Statistics'),
                          Text('Activity'),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ],
              ),
              if (strategyViewModel.selectedView == TabView.overview) ...[
                Overview(strategyName: strategy.nickname),
              ] else if (strategyViewModel.selectedView == TabView.stats) ...[
                Statistics(strategyName: strategy.nickname),
              ] else if (strategyViewModel.selectedView == TabView.activity) ...[
                Activity(strategyName: strategy.nickname),
              ]
            ],
          ),
        ),
        if (strategyViewModel.errorMessage != null) ...[
          ErrorDialog(
            onDismiss: () {
              strategyViewModel.setErrorMessage(null);
            },
            error: strategyViewModel.errorMessage,
          ),
        ],
        if (infoBubbleViewModel.shouldShowBubble) ...[
          GestureDetector(
            onTap: () => infoBubbleViewModel.removeBubble(),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Positioned(
            top: infoBubbleViewModel.tapUpDetails.globalPosition.dy -
                (infoBubbleViewModel.direction == Direction.up ? 135 : 0),
            left: infoBubbleViewModel.tapUpDetails.globalPosition.dx -
                (infoBubbleViewModel.direction == Direction.up ? 90 : 60),
            child: Material(
              color: Colors.transparent,
              child: ChatBubble(
                clipper: MyBubbleClipper(direction: infoBubbleViewModel.direction),
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(top: 25),
                backGroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: Text(
                    infoBubbleViewModel.info,
                    style: const TextStyle(color: kColorPrimary, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
