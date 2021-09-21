import 'package:copy_trading/global/lock_manager.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/providers/token_provider.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future initialize() async {
    final tokenViewModel = context.read(tokenProvider);
    await tokenViewModel.initialize();
    Navigator.pushReplacementNamed(
        context, tokenViewModel.authenticated ? Routes.tabController : Routes.home);
    if (tokenViewModel.authenticated) {
      locator<LockManager>().lockApp(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
