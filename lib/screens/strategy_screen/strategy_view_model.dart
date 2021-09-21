import 'package:copy_trading/api/core/api_exporter.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/activity_details.dart';
import 'package:copy_trading/models/chart_data.dart';
import 'package:copy_trading/models/stats_details.dart';
import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/providers/core/default_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StatsType { growth, profit, balance }
enum TabView { overview, stats, activity }
enum ActivityType { open, closed }

final strategyProvider =
    ChangeNotifierProvider.autoDispose.family<StrategyViewModel, String>((ref, name) {
  return StrategyViewModel(name);
});

class StrategyViewModel extends DefaultChangeNotifier {
  final String name;
  final ApiExporter api = locator<ApiExporter>();

  TabView selectedView = TabView.overview;
  ActivityType activityType = ActivityType.closed;
  StatsType selectedChart = StatsType.growth;

  StrategyDetails strategyDetails;
  StatsDetails statsDetails;

  ChartData latestChartData;
  ChartData growthData;
  ChartData profitData;
  ChartData balanceData;

  DateTime selectedYearDate = DateTime.now();
  DateTime selectedMonthDate;

  bool chartLoading = false;

  ActivityResponse lastOpenResponse;
  ActivityResponse lastClosedResponse;
  bool loadingMoreActivities = false;

  Set<ActivityDetails> openActivities = {};
  Set<ActivityDetails> closeActivities = {};
  Set<ActivityDetails> get activities =>
      activityType == ActivityType.open ? openActivities : closeActivities;

  ChartData get selectedChartData {
    switch (selectedChart) {
      case StatsType.growth:
        return growthData;
        break;
      case StatsType.profit:
        return profitData;
        break;
      case StatsType.balance:
        return balanceData;
        break;
      default:
        return growthData;
        break;
    }
  }

  List<DateTime> get availableChartYears {
    final List<String> cache = [];
    final List<DateTime> results = [];
    latestChartData?.dataList?.data?.forEach((element) {
      if (!cache.contains(element.date.year.toString())) {
        cache.add(element.date.year.toString());
        results.add(element.date);
      }
    });
    return results.reversed.toList();
  }

  List<DateTime> get availableChartMonths {
    final List<String> cache = [];
    final List<DateTime> results = [];
    if (selectedYearDate == null && availableChartYears.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setChartYear(availableChartYears.last);
      });
    }
    latestChartData?.dataList?.data
        ?.where((element) => element.date.year == selectedYearDate?.year)
        ?.forEach((element) {
      if (!cache.contains(element.date.month.toString())) {
        cache.add(element.date.month.toString());
        results.add(element.date);
      }
    });
    return results;
  }

  StrategyViewModel(this.name) {
    getDetails();
  }

  Future getDetails() async {
    try {
      toggleLoadingOn(true);
      strategyDetails = await api.getStrategyDetails(name);
    } on String catch (e, stack) {
      debugPrint(e);
      debugPrint(stack.toString());
      // setErrorMessage(e);
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future getStats() async {
    try {
      toggleLoadingOn(true);
      statsDetails = await api.getStatsDetails(name);
      await getChart(StatsType.growth, firstFetch: true);
    } on String catch (e, stack) {
      debugPrint(e);
      debugPrint(stack.toString());
      // setErrorMessage(e);
    } finally {
      toggleLoadingOn(false);
    }
  }

  Future getChart(StatsType type, {bool firstFetch = false}) async {
    final DateTime startDate = firstFetch ? null : _startDate();
    final DateTime endDate = firstFetch ? null : _endDate();

    try {
      switch (type) {
        case StatsType.growth:
          selectedChart = StatsType.growth;
          toggleChartLoading(on: true);
          growthData = await api.getStatChart(
            name: name,
            type: type,
            startDate: startDate,
            endDate: endDate,
          );
          if (firstFetch) {
            latestChartData = ChartData.fromMap(growthData.toMap());
            final List<ChartPoint> filteredData = growthData?.dataList?.data
                    ?.where((element) => element.date.year == selectedYearDate.year)
                    ?.toList() ??
                [];
            growthData?.dataList?.data?.clear();
            growthData?.dataList?.data?.addAll(filteredData);
          }
          toggleChartLoading(on: false);
          break;
        case StatsType.profit:
          selectedChart = StatsType.profit;
          toggleChartLoading(on: true);
          profitData = await api.getStatChart(
            name: name,
            type: type,
            startDate: startDate,
            endDate: endDate,
          );
          if (firstFetch) {
            latestChartData = ChartData.fromMap(profitData.toMap());
            final List<ChartPoint> filteredData = profitData?.dataList?.data
                    ?.where((element) => element.date.year == selectedYearDate.year)
                    ?.toList() ??
                [];
            profitData?.dataList?.data?.clear();
            profitData?.dataList?.data?.addAll(filteredData);
          }
          toggleChartLoading(on: false);
          break;
        case StatsType.balance:
          selectedChart = StatsType.balance;
          toggleChartLoading(on: true);
          balanceData = await api.getStatChart(
            name: name,
            type: type,
            startDate: startDate,
            endDate: endDate,
          );
          if (firstFetch) {
            latestChartData = ChartData.fromMap(balanceData.toMap());
            final List<ChartPoint> filteredData = balanceData?.dataList?.data
                    ?.where((element) => element.date.year == selectedYearDate.year)
                    ?.toList() ??
                [];
            balanceData?.dataList?.data?.clear();
            balanceData?.dataList?.data?.addAll(filteredData);
          }
          toggleChartLoading(on: false);
          break;
      }
    } on String catch (e, stack) {
      debugPrint(e.toString());
      debugPrint(stack.toString());
      if (e is String) {
        // errorMessage = e;
      }
    } finally {
      toggleChartLoading(on: false);
    }
  }

  DateTime _startDate() {
    final DateTime now = DateTime.now();
    if (selectedMonthDate != null) {
      return DateTime(selectedMonthDate.year, selectedMonthDate.month);
    }
    if (selectedYearDate != null) {
      return DateTime(selectedYearDate.year);
    }
    return DateTime(now.year);
  }

  DateTime _endDate() {
    if (selectedMonthDate != null) {
      return _startDate().add(const Duration(days: 30));
    }
    return _startDate().add(const Duration(days: 365));
  }

  void toggleChartLoading({bool on}) {
    chartLoading = on;
    notifyListeners();
  }

  void clearFilters() {
    final DateTime now = DateTime.now();
    selectedYearDate = DateTime(now.year);
    selectedMonthDate = null;
  }

  Future getActivity({bool refresh = false}) async {
    if (refresh) {
      errorMessage = null;
      if (activityType == ActivityType.open) {
        lastOpenResponse = null;
        openActivities.clear();
      } else {
        lastClosedResponse = null;
        closeActivities.clear();
      }
    }

    final ActivityResponse targetResponse =
        activityType == ActivityType.open ? lastOpenResponse : lastClosedResponse;
    final bool loadingMore = targetResponse != null;
    final nextPageExists =
        targetResponse?.responseData?.nextPageUrl != null && errorMessage == null;

    if (loadingMoreActivities || loadingMore && !nextPageExists) {
      return;
    }
    try {
      if (loadingMore) {
        loadingMoreActivities = true;
        notifyListeners();
      } else {
        toggleLoadingOn(true);
      }
      final page = int.tryParse(targetResponse?.responseData?.currentPage ?? '0') + 1;
      final ActivityResponse response = nextPageExists
          ? await api.getActivitiesWithUrl(targetResponse.responseData.nextPageUrl)
          : await api.getActivities(
              strategyName: name,
              type: activityType == ActivityType.open ? 'Opened' : 'Closed',
              page: page,
            );

      if (activityType == ActivityType.open) {
        lastOpenResponse = response;
        openActivities
            .addAll(response.responseData.activities.where((element) => element.date != null));
      } else {
        lastClosedResponse = response;
        closeActivities
            .addAll(response.responseData.activities.where((element) => element.date != null));
      }
    } on String catch (e, stack) {
      debugPrint(e);
      debugPrint(stack.toString());
      // setErrorMessage(e);
    } finally {
      if (loadingMore) {
        loadingMoreActivities = false;
        notifyListeners();
      } else {
        toggleLoadingOn(false);
      }
    }
  }

  void setChartYear(DateTime time) {
    selectedYearDate = time;
    selectedMonthDate = null;
    notifyListeners();
    getChart(selectedChart);
  }

  void setChartMonth(DateTime time) {
    selectedMonthDate = time;
    notifyListeners();
    getChart(selectedChart);
  }

  void changeActivityType(ActivityType type) {
    activityType = type;
    handleViewChange();
    notifyListeners();
  }

  void changeView(TabView view) {
    selectedView = view;
    handleViewChange();
    notifyListeners();
  }

  void handleViewChange() {
    if (selectedView == TabView.overview && strategyDetails == null) {
      getDetails();
    }
    if (selectedView == TabView.stats && statsDetails == null) {
      getStats();
    }
    if (selectedView == TabView.activity) {
      if (activityType == ActivityType.open && openActivities.isEmpty) {
        getActivity();
      } else if (activityType == ActivityType.closed && closeActivities.isEmpty) {
        getActivity();
      }
    }
  }
}
