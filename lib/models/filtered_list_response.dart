import 'package:copy_trading/models/strategy_details.dart';
import 'package:flutter/foundation.dart';

class FilteredResponseData {
  FilteredResponseData({
    @required this.currentPage,
    @required this.strategies,
    @required this.firstPageUrl,
    @required this.from,
    @required this.lastPage,
    @required this.lastPageUrl,
    @required this.nextPageUrl,
    @required this.path,
    @required this.perPage,
    @required this.prevPageUrl,
    @required this.to,
    @required this.total,
  });

  final String currentPage;
  final List<StrategyDetails> strategies;
  final String firstPageUrl;
  final String from;
  final String lastPage;
  final String lastPageUrl;
  final String nextPageUrl;
  final String path;
  final String perPage;
  final String prevPageUrl;
  final String to;
  final String total;

  factory FilteredResponseData.fromMap(Map<String, dynamic> json) {
    final data = json['data'] as List;
    return FilteredResponseData(
      currentPage: json["current_page"]?.toString(),
      strategies: (data?.isNotEmpty ?? false)
          ? List<StrategyDetails>.from(
              data.map((x) => StrategyDetails.fromMap(x as Map<String, dynamic>)))
          : [],
      firstPageUrl: json["first_page_url"]?.toString(),
      from: json["from"]?.toString(),
      lastPage: json["last_page"]?.toString(),
      lastPageUrl: json["last_page_url"]?.toString(),
      nextPageUrl: json["next_page_url"]?.toString(),
      path: json["path"]?.toString(),
      perPage: json["per_page"]?.toString(),
      prevPageUrl: json["prev_page_url"]?.toString(),
      to: json["to"]?.toString(),
      total: json["total"]?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(strategies.map((x) => x.toMap())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}
