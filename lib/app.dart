import 'package:copy_trading/router/app_router.dart';
import 'package:copy_trading/router/route_names.dart';
import 'package:copy_trading/util/app_themes.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildWithTheme(context, appThemeData[AppTheme.lightTheme]);
  }

  Widget _buildWithTheme(BuildContext context, ThemeData theme) {
    return MaterialApp(
      initialRoute: Routes.splash,
      onGenerateRoute: AppRouter.router,
      debugShowCheckedModeBanner: false,
      title: 'Copy Trading',
      theme: theme,
    );
  }
}
