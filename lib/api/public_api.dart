import 'package:copy_trading/api/core/api_core.dart';
import 'package:copy_trading/api/core/api_links.dart';
import 'package:copy_trading/locator/locator.dart';
import 'package:copy_trading/models/activity_details.dart';
import 'package:copy_trading/models/chart_data.dart';
import 'package:copy_trading/models/filtered_list_response.dart';
import 'package:copy_trading/models/stats_details.dart';
import 'package:copy_trading/models/strategy_details.dart';
import 'package:copy_trading/models/strategy_list.dart';
import 'package:copy_trading/screens/strategy_screen/strategy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin PublicApi on ApiCore {
  static const fileName = 'PublicApi';
  final ApiLinks apiLinks = locator<ApiLinks>();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Future<StrategyList> getStrategiesList() async {
    final Uri uri = Uri.parse(apiLinks.strategyList);
    final response = await apiClient.post(uri, headers: defaultHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return StrategyList.fromMap(json['details'] as Map<String, dynamic>);
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<FilteredResponseData> getFilteredStrategiesList(
      {@required String type, int page = 1, String timeFilter = '1w'}) async {
    final now = DateTime.now();
    final Map<String, dynamic> body = {
      'type': type,
      'start_date': dateFormat.format(now),
      'end_date': timeFilter,
    };

    try {
      final Uri uri = Uri.parse(apiLinks.strategyList);
      final response = await apiClient.post(uri, body: jsonEncode(body), headers: defaultHeaders);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return FilteredResponseData.fromMap(json['details'] as Map<String, dynamic>);
      } else {
        throw json['error'] ?? 'Error in $fileName';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<FilteredResponseData> getFilteredStrategiesListWithUrl(String url) async {
    final Uri uri = Uri.parse(url);
    final response = await apiClient.post(uri, headers: defaultHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return FilteredResponseData.fromMap(json['details'] as Map<String, dynamic>);
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<StrategyDetails> getStrategyDetails(String name) async {
    final Uri uri = Uri.parse(apiLinks.strategyDetails);
    final response =
        await apiClient.post(uri, body: jsonEncode({'strategy': name}), headers: defaultHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      final StrategyDetailsResponse res = StrategyDetailsResponse.fromMap(json);
      if (res.details.data.isNotEmpty) {
        return res.details.data.first;
      } else {
        throw 'No data found';
      }
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<StatsDetails> getStatsDetails(String name) async {
    final Uri uri = Uri.parse(apiLinks.statistics);
    final response =
        await apiClient.post(uri, body: jsonEncode({'strategy': name}), headers: defaultHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      final StatsResponse res = StatsResponse.fromMap(json);
      if (res.details.data.isNotEmpty) {
        return res.details.data.first;
      } else {
        throw 'No data found';
      }
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<ChartData> getStatChart(
      {String name, StatsType type, DateTime startDate, DateTime endDate}) async {
    String link;
    switch (type) {
      case StatsType.growth:
        link = apiLinks.growth;
        break;
      case StatsType.profit:
        link = apiLinks.profit;
        break;
      case StatsType.balance:
        link = apiLinks.balance;
        break;
    }

    final Uri uri = Uri.parse(link);
    final Map parameters = {'strategy': name};
    if (endDate != null && startDate != null) {
      parameters['start_date'] = dateFormat.format(startDate);
      parameters['end_date'] = dateFormat.format(endDate);
    }
    final response =
        await apiClient.post(uri, body: jsonEncode(parameters), headers: defaultHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final ChartData res = ChartData.fromMap(json);
      if (res.dataList.data.isNotEmpty) {
        return res;
      } else {
        throw 'No data found';
      }
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<ActivityResponse> getActivities(
      {@required String strategyName, @required String type, int page = 1}) async {
    final Uri uri = Uri.parse(apiLinks.activity);
    final response = await apiClient.post(uri,
        body: jsonEncode({
          'strategy': strategyName,
          'platform': 'MT4',
          'tradetype': type,
          'page%5Bnumber%5D': page
        }),
        headers: defaultHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      final ActivityResponse res = ActivityResponse.fromMap(json);
      return res;
    } else {
      throw json['error'] ?? 'Error in $fileName';
    }
  }

  Future<ActivityResponse> getActivitiesWithUrl(String url) async {
    final Uri uri = Uri.parse(url);
    final response = await apiClient.post(uri, headers: defaultHeaders);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200 && json['strategy'] != null) {
      final ActivityResponse res = ActivityResponse.fromMap(json);
      return res;
    } else {
      throw json['message'] ?? 'Error in $fileName';
    }
  }
}
