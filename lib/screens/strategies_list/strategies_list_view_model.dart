import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/filtered_list_response.dart';
import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final strategiesListProvider = ChangeNotifierProvider.family
    .autoDispose<StrategiesListViewModel, String>((ref, type) => StrategiesListViewModel(type));

class StrategiesListViewModel extends DefaultChangeNotifier {
  final ApiExporter api = locator<ApiExporter>();
  final String type;
  String activeFilter = '1w';
  bool loadingMore = false;
  FilteredResponseData latestResponseData;
  final List<StrategyDetails> strategies = [];

  int get nextPage {
    if (latestResponseData == null) {
      return 1;
    }
    if (latestResponseData?.nextPageUrl == null) {
      return null;
    }
    return (int.tryParse(latestResponseData.currentPage) ?? 1) + 1;
  }

  StrategiesListViewModel(this.type) {
    getList(refresh: true);
  }

  Future getList({bool refresh = false, String filter}) async {
    if (refresh) {
      strategies.clear();
      latestResponseData = null;
    }

    if (refresh || nextPage != null) {
      if (nextPage != null && !refresh) {
        loadingMore = true;
      }
      toggleLoadingOn(true);
      try {
        latestResponseData = latestResponseData?.nextPageUrl != null
            ? await api.getFilteredStrategiesListWithUrl(latestResponseData.nextPageUrl)
            : await api.getFilteredStrategiesList(type: type, page: nextPage, timeFilter: filter);
        strategies.addAll(latestResponseData.strategies);
      } catch (e) {
        setErrorMessage(e?.toString());
      } finally {
        loadingMore = false;
        toggleLoadingOn(false);
      }
    }
  }

  void applyFilter(String filter) {
    activeFilter = filter;
    getList(refresh: true, filter: filter);
  }
}
