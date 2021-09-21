import 'package:copy_trading/screens/tab_controller/tab_controller_view_model.dart';
import 'package:copy_trading/screens/wallet/wallet_screen.dart';
import 'package:copy_trading/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabBarController extends StatefulWidget {
  @override
  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController> with SingleTickerProviderStateMixin {
  TabController controller;
  static const tabs = [
    HomeTabs.favorites,
    HomeTabs.portfolio,
    HomeTabs.wallet,
    HomeTabs.settings,
  ];

  @override
  void initState() {
    controller = TabController(length: tabs.length, vsync: this, initialIndex: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (cxt, watch, _) {
        final tabViewModel = watch(tabControllerProvider);
        final _selectedIndex = watch(tabControllerProvider.state);
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                      offset: Offset(
                        10.0,
                        10.0,
                      ))
                ],
              ),
              child: SafeArea(
                child: TabBar(
                    controller: controller,
                    onTap: (index) {
                      tabViewModel.changeTab(tabs[index]);
                    },
                    indicator: const ShapeDecoration(
                      shape: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: kColorAccent,
                        ),
                      ),
                    ),
                    tabs: <Tab>[
                      Tab(
                        icon: SvgPicture.asset(
                          'assets/images/favorites_icon.svg',
                          color:
                              _selectedIndex == HomeTabs.favorites ? kColorAccent : kColorPrimary,
                        ),
                      ),
                      Tab(
                        icon: SvgPicture.asset(
                          'assets/images/portfolio_icon.svg',
                          color:
                              _selectedIndex == HomeTabs.portfolio ? kColorAccent : kColorPrimary,
                        ),
                      ),
                      Tab(
                        icon: SvgPicture.asset(
                          'assets/images/wallet_icon.svg',
                          color: _selectedIndex == HomeTabs.wallet ? kColorAccent : kColorPrimary,
                        ),
                      ),
                      Tab(
                        icon: SvgPicture.asset(
                          'assets/images/settings_icon.svg',
                          color: _selectedIndex == HomeTabs.settings ? kColorAccent : kColorPrimary,
                        ),
                      ),
                    ]),
              ),
            ),
            body: TabBarView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                const Scaffold(),
                const Scaffold(),
                WalletScreen(),
                const Scaffold(),
              ],
            ),
          ),
        );
      },
    );
  }
}
