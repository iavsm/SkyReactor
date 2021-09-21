import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/strategy_list.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final strategyListProvider = ChangeNotifierProvider((ref) => StrategyListProvider());

class StrategyListProvider extends DefaultChangeNotifier {
  final ApiExporter api = locator<ApiExporter>();
  StrategyList _strategyList;
  StrategyList get strategyList {
    return _strategyList ??
        StrategyList.fromMap({
          "details": {
            "topgainers": {"title": "Top Gainers", "data": []},
            "mostpopular": {"title": "Most Popular", "data": []},
            "commission": {"title": "Commission", "data": []},
            "drawdown": {"title": "Draw Down", "data": []}
          }
        });
  }

  StrategyListProvider() {
    getList();
  }

  Future<void> getList() async {
    try {
      toggleLoadingOn(true);
      _strategyList = await api.getStrategiesList();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      toggleLoadingOn(false);
    }
  }
}
