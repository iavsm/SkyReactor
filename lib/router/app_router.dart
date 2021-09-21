import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/screens/forgot_password/forgot_password_screen.dart';
import 'package:copy_trading/screens/home/home_screen.dart';
import 'package:copy_trading/screens/login/login_screen.dart';
import 'package:copy_trading/screens/register/register_screen.dart';
import 'package:copy_trading/screens/reset_password/reset_password_screen.dart';
import 'package:copy_trading/screens/splash/splash_screen.dart';
import 'package:copy_trading/screens/strategies_list/strategies_list_screen.dart';
import 'package:copy_trading/screens/strategy_screen/strategy_screen.dart';
import 'package:copy_trading/screens/tab_controller/tab_controller.dart';
import 'package:copy_trading/screens/wallet/payment_webview.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route router(RouteSettings settings) {
    final dynamic args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.tabController:
        return MaterialPageRoute(builder: (_) => TabBarController());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case Routes.strategiesList:
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => StrategiesListScreen(
                    title: args['title'] as String,
                    type: args['type'] as String,
                  ));
        } else {
          return _errorRoute();
        }
        break;
      case Routes.strategyScreen:
        if (args is StrategyDetails) {
          return MaterialPageRoute(builder: (_) => StrategyScreen(strategy: args));
        } else {
          return _errorRoute();
        }
        break;
      case Routes.paymentWebview:
        if (args is String) {
          return MaterialPageRoute(builder: (_) => PaymentWebview(url: args));
        } else {
          return _errorRoute();
        }
        break;
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
